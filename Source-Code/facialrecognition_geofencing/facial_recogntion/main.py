import os
import shutil
import json
import numpy as np
from fastapi import FastAPI, UploadFile, File, HTTPException, Form
from fastapi.responses import JSONResponse
from typing import Dict, Any, List
import face_recognition

# Initialize FastAPI app
app = FastAPI(
    title="Student Face Recognition API",
    description="API for registering students with their faces and recognizing them with high accuracy.",
    version="2.0.0"
)

# Directory to store registered face images and encodings
REGISTERED_FACES_DIR = "registered_faces"
ENCODINGS_FILE = os.path.join(REGISTERED_FACES_DIR, "encodings.json")

# In-memory storage for known face encodings and student IDs
# This will be loaded from and saved to ENCODINGS_FILE
known_face_encodings: List[List[float]] = []
known_face_names: List[str] = []

# --- Configuration for Accuracy ---
# A lower value means a stricter match (less tolerant to differences).
# Typical values range from 0.4 to 0.6.
# 0.6 is a common good balance. For "very very accurate", you might try 0.5 or 0.4,
# but be aware that this might lead to more "Unknown" results even for the same person
# due to slight variations in lighting, angle, or expression.
RECOGNITION_TOLERANCE = 0.6 

# --- Helper Functions ---

def ensure_directory_exists(path: str):
    """Ensures a directory exists, creates it if not."""
    os.makedirs(path, exist_ok=True)

def save_encoding_data():
    """Saves the current known encodings and names to a JSON file."""
    data = {
        "encodings": [encoding.tolist() for encoding in known_face_encodings],
        "names": known_face_names
    }
    with open(ENCODINGS_FILE, "w") as f:
        json.dump(data, f)

def load_encoding_data():
    """Loads known encodings and names from a JSON file."""
    global known_face_encodings, known_face_names
    if os.path.exists(ENCODINGS_FILE):
        try:
            with open(ENCODINGS_FILE, "r") as f:
                data = json.load(f)
                # Convert list of lists back to numpy arrays for face_recognition
                known_face_encodings = [np.array(enc) for enc in data.get("encodings", [])]
                known_face_names = data.get("names", [])
            print(f"Loaded {len(known_face_names)} known faces.")
        except json.JSONDecodeError:
            print("Error decoding encodings.json, starting with empty data.")
            # Reset in case of malformed JSON
            known_face_encodings = []
            known_face_names = []
        except Exception as e:
            print(f"An unexpected error occurred while loading encodings: {e}")
            known_face_encodings = []
            known_face_names = []
    else:
        print("No encodings.json found, starting with empty data.")
        known_face_encodings = []
        known_face_names = []

@app.on_event("startup")
async def startup_event():
    """Ensures the storage directory exists and loads existing data on startup."""
    ensure_directory_exists(REGISTERED_FACES_DIR)
    load_encoding_data()

# --- API Endpoints ---

@app.post("/register_student", summary="Register a new student with their face")
async def register_student(
    student_id: str = Form(..., description="Unique ID for the student"),
    file: UploadFile = File(..., description="Image file of the student's face. Must contain exactly one face.")
):
    """
    Registers a new student by saving their image and encoding their face.
    The uploaded image *must* contain exactly one face for accurate registration.
    If the student ID already exists, it will return an error (use PUT /update_student_face/{student_id} to update).
    """
    # Check if student_id is already registered
    if student_id in known_face_names:
        raise HTTPException(
            status_code=400,
            detail=f"Student ID '{student_id}' already registered. Use PUT /update_student_face/ to update."
        )

    # Sanitize student_id for filename (remove characters that might cause issues)
    sanitized_student_id = "".join(c for c in student_id if c.isalnum() or c in (' ', '.', '_')).strip()
    if not sanitized_student_id:
        sanitized_student_id = "unknown_id" # Fallback if ID becomes empty after sanitization

    # Save the uploaded image temporarily with a descriptive name
    file_extension = os.path.splitext(file.filename)[1]
    temp_file_name = f"{sanitized_student_id}_registration{file_extension}"
    temp_file_path = os.path.join(REGISTERED_FACES_DIR, temp_file_name)
    
    try:
        with open(temp_file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Could not save file: {e}")

    try:
        # Load the image and find face encodings
        image = face_recognition.load_image_file(temp_file_path)
        face_encodings = face_recognition.face_encodings(image)

        if not face_encodings:
            os.remove(temp_file_path) # Clean up temp file
            raise HTTPException(status_code=400, detail="No face found in the provided image for registration.")
        
        if len(face_encodings) > 1:
            os.remove(temp_file_path) # Clean up temp file
            raise HTTPException(status_code=400, detail=f"Multiple faces ({len(face_encodings)}) found in the image. Please provide an image with exactly one face for accurate registration.")

        # There should be exactly one face encoding based on the check above
        face_encoding = face_encodings[0]

        # Add the new encoding and name to our lists
        known_face_encodings.append(face_encoding)
        known_face_names.append(student_id)

        # Persist data to file
        save_encoding_data()

        return JSONResponse(
            status_code=200,
            content={"message": f"Student '{student_id}' registered successfully!"}
        )
    except Exception as e:
        # Clean up the temporarily saved file in case of error
        if os.path.exists(temp_file_path):
            os.remove(temp_file_path)
        # Re-raise as HTTPException with specific detail
        raise HTTPException(status_code=500, detail=f"Error processing image for registration: {e}")

@app.put("/update_student_face/{student_id}", summary="Update a student's face image")
async def update_student_face(
    student_id: str,
    file: UploadFile = File(..., description="New image file of the student's face. Must contain exactly one face.")
):
    """
    Updates the face image for an existing student.
    The uploaded image *must* contain exactly one face for accurate updating.
    """
    try:
        # Find the index of the student to update
        idx = known_face_names.index(student_id)
    except ValueError:
        raise HTTPException(status_code=404, detail=f"Student ID '{student_id}' not found.")

    # Sanitize student_id for filename
    sanitized_student_id = "".join(c for c in student_id if c.isalnum() or c in (' ', '.', '_')).strip()
    if not sanitized_student_id:
        sanitized_student_id = "unknown_id"

    # Save the uploaded image temporarily with a descriptive name
    file_extension = os.path.splitext(file.filename)[1]
    temp_file_name = f"{sanitized_student_id}_update{file_extension}"
    temp_file_path = os.path.join(REGISTERED_FACES_DIR, temp_file_name)

    try:
        with open(temp_file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Could not save file: {e}")

    try:
        image = face_recognition.load_image_file(temp_file_path)
        face_encodings = face_recognition.face_encodings(image)

        if not face_encodings:
            os.remove(temp_file_path)
            raise HTTPException(status_code=400, detail="No face found in the provided image for update.")
            
        if len(face_encodings) > 1:
            os.remove(temp_file_path)
            raise HTTPException(status_code=400, detail=f"Multiple faces ({len(face_encodings)}) found in the image. Please provide an image with exactly one face for accurate update.")

        # Update the existing encoding at the found index
        known_face_encodings[idx] = face_encodings[0] # Take the first face found (which is now guaranteed to be the only one)

        # Persist data to file
        save_encoding_data()

        return JSONResponse(
            status_code=200,
            content={"message": f"Face for student '{student_id}' updated successfully!"}
        )
    except Exception as e:
        if os.path.exists(temp_file_path):
            os.remove(temp_file_path)
        raise HTTPException(status_code=500, detail=f"Error processing image for update: {e}")


@app.post("/recognize_face", summary="Recognize a face from an image")
async def recognize_face(
    file: UploadFile = File(..., description="Image file containing the face(s) to recognize")
):
    """
    Recognizes a face from the provided image against registered student faces.
    It will attempt to find the best match for any face detected in the image.
    Returns the student ID and the face distances if a match is found.
    """
    if not known_face_encodings:
        raise HTTPException(status_code=404, detail="No registered faces found in the system. Please register students first.")

    # Save the uploaded image temporarily
    file_extension = os.path.splitext(file.filename)[1]
    temp_file_name = f"recognition_attempt{file_extension}" # Generic name for recognition temp files
    temp_file_path = os.path.join(REGISTERED_FACES_DIR, temp_file_name)

    try:
        with open(temp_file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Could not save file: {e}")

    try:
        # Load the image and find ALL face encodings in the unknown image
        unknown_image = face_recognition.load_image_file(temp_file_path)
        unknown_face_encodings = face_recognition.face_encodings(unknown_image)

        if not unknown_face_encodings:
            os.remove(temp_file_path) # Clean up temp file
            raise HTTPException(status_code=400, detail="No face found in the provided image for recognition.")

        best_overall_match_id = "Unknown"
        lowest_overall_distance = float('inf') # Initialize with a very high distance
        best_match_distances_to_all_known = [] # To store distances for the best matched unknown face

        # Iterate through all faces found in the unknown image
        for unknown_face_encoding in unknown_face_encodings:
            # Compare this unknown face with all known faces
            # The lower the distance, the better the match.
            current_face_distances = face_recognition.face_distance(known_face_encodings, unknown_face_encoding)
            
            # Check if there are any known faces to compare against
            if not current_face_distances.size > 0:
                continue # Skip if no known faces for comparison

            # Find the best match among known faces for the current unknown face
            best_match_index_for_current_unknown = np.argmin(current_face_distances)
            current_best_distance = current_face_distances[best_match_index_for_current_unknown]

            # If this match is better than the overall best so far and within tolerance
            if current_best_distance < lowest_overall_distance and current_best_distance < RECOGNITION_TOLERANCE:
                lowest_overall_distance = current_best_distance
                best_overall_match_id = known_face_names[best_match_index_for_current_unknown]
                best_match_distances_to_all_known = current_face_distances.tolist() # Convert to list for JSON response
        
        os.remove(temp_file_path) # Clean up temp file

        if best_overall_match_id != "Unknown":
            return JSONResponse(
                status_code=200,
                content={
                    "message": "Face recognized!",
                    "student_id": best_overall_match_id,
                    "match_distance": round(lowest_overall_distance, 4), # Rounded for readability
                    "distances_to_all_registered_students": {
                        name: round(dist, 4) for name, dist in zip(known_face_names, best_match_distances_to_all_known)
                    },
                    "recognition_tolerance_applied": RECOGNITION_TOLERANCE
                }
            )
        else:
            # If no match found, still provide some info if any faces were detected
            if unknown_face_encodings:
                # For an "Unknown" result, we can still show the distances to the closest known face
                # This helps in debugging or understanding why it wasn't recognized.
                # Take the distances for the first detected unknown face, or the one with the lowest overall distance (even if above tolerance)
                # For simplicity, we'll just show the distances for the first face detected in the unknown image,
                # if no "best_overall_match_id" was found.
                if len(unknown_face_encodings) > 0:
                     first_face_distances_raw = face_recognition.face_distance(known_face_encodings, unknown_face_encodings[0])
                     first_face_distances_dict = {name: round(dist, 4) for name, dist in zip(known_face_names, first_face_distances_raw)}
                else:
                    first_face_distances_dict = {} # Should not happen if unknown_face_encodings is not empty

                return JSONResponse(
                    status_code=404,
                    content={
                        "message": "Face not recognized. No sufficiently close match found.",
                        "student_id": "Unknown",
                        "distances_to_registered_students_for_first_detected_face": first_face_distances_dict,
                        "recognition_tolerance_applied": RECOGNITION_TOLERANCE
                    }
                )
            else:
                 return JSONResponse(
                    status_code=400,
                    content={
                        "message": "No face found in the provided image for recognition.",
                        "student_id": "Unknown",
                        "recognition_tolerance_applied": RECOGNITION_TOLERANCE
                    }
                )
    except Exception as e:
        if os.path.exists(temp_file_path):
            os.remove(temp_file_path)
        # Provide a more informative error message
        raise HTTPException(status_code=500, detail=f"Error processing image for recognition: {e}. Ensure 'face_recognition' library is correctly installed and updated.")

@app.get("/students", summary="Get a list of all registered student IDs")
async def get_students():
    """
    Returns a list of all student IDs currently registered in the system.
    """
    if not known_face_names:
        return JSONResponse(
            status_code=200,
            content={"message": "No students registered yet.", "students": []}
        )
    return JSONResponse(
        status_code=200,
        content={"message": f"{len(known_face_names)} students registered.", "students": known_face_names}
    )

@app.delete("/delete_student/{student_id}", summary="Delete a registered student and their face data")
async def delete_student(student_id: str):
    """
    Deletes a student and their associated face data from the system.
    """
    try:
        idx = known_face_names.index(student_id)
        # Remove from lists
        known_face_names.pop(idx)
        known_face_encodings.pop(idx)

        # Persist data
        save_encoding_data()

        return JSONResponse(
            status_code=200,
            content={"message": f"Student '{student_id}' and associated face data deleted successfully."}
        )
    except ValueError:
        raise HTTPException(status_code=404, detail=f"Student ID '{student_id}' not found.")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error deleting student: {e}")

