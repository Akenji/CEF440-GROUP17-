# controller_wifi_geo.py
"""
Module for geofence and Wi-Fi proximity logic, combining geographic location checks
with Wi-Fi signal strength verification for access control.
"""

import json
import math
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Akenji's GeoJSON data for geofence (active geofence)
akenji_geofence_json = {
    "type": "Feature",
    "properties": {
        "name": "Akenji's Geofence"
    },
    "geometry": {
        "type": "Polygon",
        "coordinates": [
            [
                [9.292871699021388, 4.150621391028423],
                [9.292498794652364, 4.150109919014827],
                [9.291903049688964, 4.148939161047019],
                [9.292111791705015, 4.148081348497475],
                [9.293263710224267, 4.148042696459406],
                [9.294204188000743, 4.148152187195032],
                [9.294802938282658, 4.148967832021857],
                [9.29470353975303, 4.149824507334479],
                [9.294617894060593, 4.150835821566078],
                [9.294255417817451, 4.1511666154419],
                [9.293579373622427, 4.151106569393619],
                [9.292871699021388, 4.150621391028423]
            ]
        ]
    }
}

# Set active geofence
ACTIVE_GEOFENCE_DATA = akenji_geofence_json

def is_point_in_polygon(point, polygon_coordinates):
    """
    Determines if a geographic point (longitude, latitude) lies within a polygon using
    the ray-casting algorithm.

    Args:
        point (tuple): A tuple of (longitude, latitude) for the point to check.
        polygon_coordinates (list): List of [longitude, latitude] pairs defining the
            polygon's exterior ring. First and last points must be identical.

    Returns:
        bool: True if the point is inside the polygon, False otherwise.
    """
    longitude, latitude = point
    num_vertices = len(polygon_coordinates)
    inside = False

    p1_lon, p1_lat = polygon_coordinates[0]
    for i in range(num_vertices + 1):
        p2_lon, p2_lat = polygon_coordinates[i % num_vertices]
        if latitude > min(p1_lat, p2_lat):
            if latitude <= max(p1_lat, p2_lat):
                if longitude <= max(p1_lon, p2_lon):
                    if p1_lat != p2_lat:  # Avoid division by zero
                        x_intersection = (latitude - p1_lat) * (p2_lon - p1_lon) / (p2_lat - p1_lat) + p1_lon
                    else:
                        x_intersection = float('inf')  # No intersection for horizontal segments
                    if p1_lon == p2_lon or longitude <= x_intersection:
                        inside = not inside
        p1_lon, p1_lat = p2_lon, p2_lat
    return inside

def check_wifi_proximity(rssi, threshold_dbm):
    """
    Verifies if Wi-Fi signal strength (RSSI) meets or exceeds the threshold.
    RSSI values are negative; closer to 0 indicates stronger signal (e.g., -50 dBm > -80 dBm).

    Args:
        rssi (int): Received Signal Strength Indicator in dBm.
        threshold_dbm (int): Minimum acceptable RSSI threshold.

    Returns:
        bool: True if RSSI is strong enough, False otherwise.
    """
    return rssi >= threshold_dbm

def check_location_and_wifi_proximity(user_longitude, user_latitude, all_visible_networks, geofence_data, target_wifi_ap_bssid, target_wifi_ap_ssid, wifi_rssi_threshold=-65):
    """
    Combines geofence and Wi-Fi proximity checks, requiring both BSSID and SSID match.

    Args:
        user_longitude (float): User's current longitude.
        user_latitude (float): User's current latitude.
        all_visible_networks (list): List of dicts with 'bssid', 'ssid', and 'rssi' keys.
        geofence_data (dict): GeoJSON data for the geofence.
        target_wifi_ap_bssid (str): Target Wi-Fi AP's MAC address.
        target_wifi_ap_ssid (str): Target Wi-Fi AP's SSID.
        wifi_rssi_threshold (int): Minimum RSSI threshold for proximity (default: -65 dBm).

    Returns:
        dict: Results of geofence and Wi-Fi checks, including status and messages.
    """
    # Validate inputs
    try:
        user_longitude = float(user_longitude)
        user_latitude = float(user_latitude)
    except (TypeError, ValueError):
        logger.error("Invalid longitude or latitude: %s, %s", user_longitude, user_latitude)
        return {"error": "Longitude and latitude must be valid numbers."}

    if not isinstance(all_visible_networks, list):
        logger.error("all_visible_networks is not a list: %s", type(all_visible_networks))
        return {"error": "all_visible_networks must be a list."}

    if not target_wifi_ap_bssid or not target_wifi_ap_ssid:
        logger.error("Invalid target Wi-Fi AP: BSSID=%s, SSID=%s", target_wifi_ap_bssid, target_wifi_ap_ssid)
        return {"error": "Target Wi-Fi AP BSSID and SSID must be provided."}

    point = (user_longitude, user_latitude)

    # Extract polygon coordinates from GeoJSON
    try:
        polygon_coords = geofence_data['geometry']['coordinates'][0]
    except (KeyError, IndexError) as e:
        logger.error("Invalid GeoJSON structure: %s", str(e))
        return {"error": "Invalid GeoJSON structure for geofence data.", "details": str(e)}

    # Geofence check
    is_inside_geofence = is_point_in_polygon(point, polygon_coords)

    # Wi-Fi proximity check
    target_ap_detected = False
    target_ap_rssi = None
    target_ap_ssid_detected = None
    normalized_target_ssid = str(target_wifi_ap_ssid).strip().lower()

    for network in all_visible_networks:
        if not isinstance(network, dict) or not all(key in network for key in ['bssid', 'ssid', 'rssi']):
            logger.warning("Invalid network entry: %s", network)
            continue
        detected_bssid = network.get('bssid', '').strip().upper()
        detected_ssid = network.get('ssid', '').strip().lower()
        if detected_bssid == target_wifi_ap_bssid.strip().upper() and detected_ssid == normalized_target_ssid:
            target_ap_detected = True
            target_ap_rssi = network.get('rssi')
            target_ap_ssid_detected = network.get('ssid', '')
            break

    is_wifi_strong_enough = False
    wifi_proximity_message = ""

    if not target_ap_detected:
        wifi_proximity_message = f"Target Wi-Fi AP (BSSID: {target_wifi_ap_bssid}, SSID: '{target_wifi_ap_ssid}') NOT detected in scan."
    elif target_ap_rssi is None:
        wifi_proximity_message = f"Target Wi-Fi AP (BSSID: {target_wifi_ap_bssid}, SSID: '{target_ap_ssid_detected}') detected, but RSSI not available."
    else:
        is_wifi_strong_enough = check_wifi_proximity(target_ap_rssi, wifi_rssi_threshold)
        if is_wifi_strong_enough:
            wifi_proximity_message = f"Target Wi-Fi AP (BSSID: {target_wifi_ap_bssid.strip().upper()}, SSID: '{target_ap_ssid_detected}') detected with strong signal ({target_ap_rssi} dBm)."
        else:
            wifi_proximity_message = f"Target Wi-Fi AP (BSSID: {target_wifi_ap_bssid.strip().upper()}, SSID: '{target_ap_ssid_detected}') detected, but signal ({target_ap_rssi} dBm) is too weak for proximity."

    # Overall status determination
    overall_status = "Access Denied"
    if is_inside_geofence:
        if target_ap_detected and is_wifi_strong_enough:
            overall_status = "Access Granted: Within Geofence and Strong Wi-Fi Proximity"
        elif target_ap_detected and not is_wifi_strong_enough:
            overall_status = "Access Denied: Within Geofence, but Wi-Fi signal too weak."
        else:
            overall_status = "Access Denied: Within Geofence, but Target Wi-Fi AP not detected or valid."
    else:
        if target_ap_detected and is_wifi_strong_enough:
            overall_status = "Access Denied: Outside Geofence (Wi-Fi proximity detected, but location takes precedence)."
        else:
            overall_status = "Access Denied: Outside Geofence and No Strong Wi-Fi Proximity."

    results = {
        "user_location": {"longitude": user_longitude, "latitude": user_latitude},
        "geofence_name": geofence_data['properties'].get('name', 'N/A'),
        "is_inside_geofence": is_inside_geofence,
        "target_wifi_ap_check": {
            "bssid_expected": target_wifi_ap_bssid,
            "ssid_expected": target_wifi_ap_ssid,
            "detected": target_ap_detected,
            "detected_ssid": target_ap_ssid_detected,
            "detected_rssi_dbm": target_ap_rssi,
            "is_strong_enough": is_wifi_strong_enough,
            "threshold_dbm": wifi_rssi_threshold
        },
        "wifi_proximity_message": wifi_proximity_message,
        "overall_status": overall_status,
        "total_visible_networks_scanned": len(all_visible_networks)
    }
    logger.info("Check results: %s", results)
    return results


    