# mainwigeo.py
"""
Flask API for checking user location within a geofence and proximity to a target
Wi-Fi access point based on BSSID and SSID.
"""

from flask import Flask, request, jsonify
import logging
from controller_wifi_geo import check_location_and_wifi_proximity, akenji_geofence_json

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Target Wi-Fi Access Point configuration
TARGET_WIFI_AP = {
    "bssid": "98:A9:42:96:9F:AF:",
    "ssid": "Data Science Nerd",
    "name": "Data Science Nerd",
    "good_proximity_rssi_threshold": -65
}

@app.route('/check_geofence_wifi', methods=['POST'])
def api_check_wifi_proximity():
    """
    API endpoint to verify if a user is within the geofence and detects the target
    Wi-Fi AP with sufficient signal strength, matching both BSSID and SSID.

    Expects JSON payload:
    {
        "longitude": float,
        "latitude": float,
        "all_visible_networks": [
            {"bssid": "XX:XX:XX:XX:XX:XX", "ssid": "NetworkName", "rssi": int},
            ...
        ]
    }

    Returns:
        JSON response with check results or error message.
    """
    data = request.get_json()
    if not data:
        logger.error("No JSON data provided in request")
        return jsonify({"error": "No JSON data provided."}), 400

    # Validate required parameters
    user_lon = data.get('longitude')
    user_lat = data.get('latitude')
    all_visible_networks = data.get('all_visible_networks')

    if None in [user_lon, user_lat, all_visible_networks]:
        logger.error("Missing required parameters: lon=%s, lat=%s, networks=%s", user_lon, user_lat, all_visible_networks)
        return jsonify({
            "error": "Missing required parameters: longitude, latitude, or all_visible_networks."
        }), 400

    if not isinstance(all_visible_networks, list):
        logger.error("all_visible_networks is not a list: %s", type(all_visible_networks))
        return jsonify({"error": "all_visible_networks must be a list."}), 400

    # Validate network entries
    for network in all_visible_networks:
        if not isinstance(network, dict) or not all(key in network for key in ['bssid', 'ssid', 'rssi']):
            logger.warning("Invalid network entry: %s", network)
            return jsonify({"error": "Each network must have bssid, ssid, and rssi keys."}), 400

    try:
        user_lon = float(user_lon)
        user_lat = float(user_lat)
    except (TypeError, ValueError):
        logger.error("Invalid longitude or latitude: %s, %s", user_lon, user_lat)
        return jsonify({"error": "Longitude and latitude must be valid numbers."}), 400

    # Call logic function
    results = check_location_and_wifi_proximity(
        user_lon,
        user_lat,
        all_visible_networks,
        akenji_geofence_json,
        TARGET_WIFI_AP["bssid"],
        TARGET_WIFI_AP["ssid"],
        TARGET_WIFI_AP["good_proximity_rssi_threshold"]
    )
    logger.info("API response: %s", results)
    return jsonify(results), 200

@app.route('/', methods=['GET'])
def home():
    """Home route to confirm API is running."""
    return "Welcome to Akenji's Geofence & Wi-Fi Proximity API! POST to /check_geofence_wifi to start."

if __name__ == '__main__':
    # WARNING: debug=True is for development only; disable in production
    logger.warning("Running in debug mode; disable debug=True in production.")
    app.run(debug=True, host='0.0.0.0', port=5000)