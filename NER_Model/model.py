import spacy
from spacy import displacy

NER = spacy.load("en_core_web_sm")
def analyse_patient_statement(text):
    doc = NER(text)
    follow_ups = []

    for ent in doc.ents:
        print(f"Identified Entity: {ent.text}, Category: {ent.label_}")
        if ent.label_ == "DISEASE":
            follow_ups.append(f"Explore treatment options for {ent.text}.")
        elif ent.label_ == "SYMPTOM":
            follow_ups.append(f"Ask about the duration and severity of {ent.text}.")
    return follow_ups
# Example usage
text = "The patient has a history of asthma and complained of severe chest pain."
follow_ups = analyse_patient_statement(text)
print("\nSuggested Follow-Up Actions:")
for action in follow_ups:
    print(f"- {action}")