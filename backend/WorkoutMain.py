from flask import Flask, request, jsonify
import pandas as pd
import pickle
from sklearn.preprocessing import LabelEncoder

app = Flask(__name__)

# Load the models
with open('workout_title_model.pkl', 'rb') as title_model_file:
    title_model = pickle.load(title_model_file)

with open('workout_reps_model.pkl', 'rb') as reps_model_file:
    reps_model = pickle.load(reps_model_file)

# Load the dataset for reference (used for label encoders and filtering results)
file_path = 'megaGymDataset_with_reps.csv'
data = pd.read_csv(file_path)

# Fill missing values for Rating
data['Rating'] = data['Rating'].fillna(data['Rating'].mean())
data['RatingDesc'] = data['RatingDesc'].fillna('No Description')

# Rebuild label encoders from the dataset
label_encoders = {}
for column in ['Title', 'Type', 'BodyPart', 'Equipment', 'Level']:
    le = LabelEncoder()
    data[column] = le.fit_transform(data[column])
    label_encoders[column] = le

# Function to suggest multiple workouts (both title and reps)
def suggest_workout_and_reps(fitness_goal, fitness_level, body_part_focus, available_equipment):
    input_data = {
        'Type': label_encoders['Type'].transform([fitness_goal])[0],
        'BodyPart': label_encoders['BodyPart'].transform([body_part_focus])[0],
        'Equipment': label_encoders['Equipment'].transform([available_equipment])[0],
        'Level': label_encoders['Level'].transform([fitness_level])[0]
    }

    input_df = pd.DataFrame([input_data])

    # Start with full match
    filtered_workouts = data[
        (data['Type'] == input_data['Type']) &
        (data['BodyPart'] == input_data['BodyPart']) &
        (data['Equipment'] == input_data['Equipment']) &
        (data['Level'] == input_data['Level'])
    ]

    # If no exact match, relax the conditions
    if filtered_workouts.empty:
        filtered_workouts = data[
            (data['Type'] == input_data['Type']) &
            (data['BodyPart'] == input_data['BodyPart'])
        ]

    # If still no match, just match by fitness goal
    if filtered_workouts.empty:
        filtered_workouts = data[data['Type'] == input_data['Type']]

    # Predict and return top workouts
    top_workouts = filtered_workouts[['Title', 'Reps']].head(5)
    
    # Decode the numeric titles back to their original text
    top_workouts['Title'] = label_encoders['Title'].inverse_transform(top_workouts['Title'])
    
    return top_workouts.to_dict(orient='records')

# API route to suggest multiple workouts
@app.route('/suggest_workouts', methods=['POST'])
def suggest_workouts():
    data_request = request.json

    fitness_goal = data_request.get('fitness_goal')
    fitness_level = data_request.get('fitness_level')
    body_part_focus = data_request.get('body_part_focus')
    available_equipment = data_request.get('available_equipment')

    # Get predictions for multiple workout titles and reps
    suggested_workouts = suggest_workout_and_reps(fitness_goal, fitness_level, body_part_focus, available_equipment)

    return jsonify({
        "suggested_workouts": suggested_workouts
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001) #changed for phone --host='0.0.0.0'
