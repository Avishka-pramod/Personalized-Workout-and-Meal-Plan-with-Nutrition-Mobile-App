import random

import pandas as pd
from flask import Flask, request, jsonify
import joblib

model = joblib.load('meal_plan_recommendation_model.pkl')
scaler = joblib.load('scaler.pkl')
le = joblib.load('label_encoder.pkl')

df = pd.read_csv('modified_dataset.csv')

if 'Meal_Type' not in df.columns:
    df['Meal_Type'] = df.apply(lambda x: random.choice(['breakfast', 'lunch', 'dinner']), axis=1)

if 'target_encoded' not in df.columns:
    df['target_encoded'] = le.transform(df['target'])

# Initialize Flask app
app = Flask(__name__)

def suggest_meals(target, time_of_day, n_meals=5):
    target_encoded = le.transform([target])[0]

    suggestions = df[(df['target_encoded'] == target_encoded) & (df['Meal_Type'] == time_of_day)][['Recipe_name', 'Protein(g)', 'Carbs(g)', 'Fat(g)']]

    if not suggestions.empty:
        meals = suggestions.sample(min(n_meals, len(suggestions)))
        meal_list = []
        for _, meal in meals.iterrows():
            meal_list.append({
                "Recipe_name": meal['Recipe_name'],
                "Protein(g)": meal['Protein(g)'],
                "Carbs(g)": meal['Carbs(g)'],
                "Fat(g)": meal['Fat(g)']
            })
        return meal_list
    else:
        return None

@app.route('/get_meal_plan', methods=['GET'])
def get_meal_plan():
    target = request.args.get('target')
    time_of_day = request.args.get('time_of_day')

    if target not in le.classes_:
        return jsonify({"error": "Invalid target. Must be one of: bulk, fat_loss, maintenance"}), 400

    if time_of_day not in ['breakfast', 'lunch', 'dinner']:
        return jsonify({"error": "Invalid time_of_day. Must be one of: breakfast, lunch, dinner"}), 400

    meal_plan = suggest_meals(target, time_of_day, n_meals=3)

    if meal_plan:
        return jsonify({"target": target, "time_of_day": time_of_day, "meals": meal_plan}), 200
    else:
        return jsonify({"error": f"No meals found for {time_of_day} with the selected target."}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
