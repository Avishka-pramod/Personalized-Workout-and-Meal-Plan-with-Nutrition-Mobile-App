import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, accuracy_score
import joblib



df = pd.read_csv('modified_dataset.csv')


features = ['Protein(g)', 'Carbs(g)', 'Fat(g)']


le = LabelEncoder()
df['target_encoded'] = le.fit_transform(df['target'])


scaler = StandardScaler()
df[features] = scaler.fit_transform(df[features])


X = df[features]
y = df['target_encoded']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)


model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)


y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f'Accuracy: {accuracy * 100:.2f}%')


print(classification_report(y_test, y_pred, target_names=le.classes_))


joblib.dump(model, 'meal_plan_recommendation_model.pkl')
joblib.dump(scaler, 'scaler.pkl')
joblib.dump(le, 'label_encoder.pkl')

print("Model, Scaler, and Label Encoder saved successfully!")


def suggest_meals(target, n_meals=5):

    loaded_model = joblib.load('meal_plan_recommendation_model.pkl')
    loaded_scaler = joblib.load('scaler.pkl')
    le = joblib.load('label_encoder.pkl')


    target_encoded = le.transform([target])[0]


    suggestions = df[df['target_encoded'] == target_encoded][['Recipe_name', 'Protein(g)', 'Carbs(g)', 'Fat(g)']]

    if not suggestions.empty:
        meals = suggestions.sample(min(n_meals, len(suggestions)))  
        print(f"Here are {len(meals)} suggested meals for the '{target}' target:\n")
        for i, meal in meals.iterrows():
            print(f"Meal: {meal['Recipe_name']}")
            print(f"Protein: {meal['Protein(g)']}, Carbs: {meal['Carbs(g)']}, Fat: {meal['Fat(g)']}")
            print("-" * 40)
    else:
        print("No meals found for the selected target.")

target_input = input("Enter your fitness goal (bulk, fat_loss, maintenance): ").strip().lower()

suggest_meals(target_input, n_meals=5)
