import spacy
import scispacy
from sentence_transformers import SentenceTransformer , util
nlp = spacy.load("en_core_sci_lg")

emergency_conditions = [
    "fracture",
    "bleeding",
    "burn",
    "pain",
    "heart attack",
    "stroke",
    "seizure",
    "loss of consciousness",
    "difficulty breathing",
    "choking",
    "severe allergic reaction",
    "head injury",
    "spinal injury",
    "suspected poisoning",
    "uncontrollable vomiting",
    "high fever",
    "sudden confusion",
    "chest pain",
    "abdominal pain",
    "severe dehydration"
]

instructions = {
    "fracture": {
        "description": "A broken or cracked bone.",
        "severity": 16,
        "actions": [
            "Immobilize the affected area. Do not attempt to straighten or realign the bone.",
            "Apply ice to reduce swelling and pain.",
            "Elevate the limb if possible.",
            "https://youtu.be/sPzXAVNVJr0?si=pv-eo9ucKJriojUo",  # Moved video_link to the last
        ]
    },
    "bleeding": {
        "description": "Significant blood loss.",
        "severity": 18,
        "actions": [
            "Apply direct pressure to the wound with a clean cloth or bandage.",
            "Elevate the wound above the heart if possible.",
            "If bleeding is severe and doesn't stop, apply a tourniquet as a last resort.",
            "https://youtu.be/8sEijZkfUHI?si=Vcww_LDn9L3aWlLP&t=16",  # Moved video_link to the last
        ]
    },
    "burn": {
        "description": "Damage to the skin caused by heat, chemicals, or electricity.",
        "severity": 14,
        "actions": [
            "Cool the burn with cool (not cold) running water for at least 10 minutes.",
            "Cover the burn loosely with a sterile bandage or clean cloth. Do not apply ointments or butter.",
            "Seek medical advice, especially for severe burns or burns covering a large area.",
            "https://youtu.be/IOtnGl_9-qw?si=VkSbQ0tSFyFtVJKI",  # Moved video_link to the last
        ]
    },
    "heart attack": {
        "description": "Blockage of blood flow to the heart.",
        "severity": 20,
        "actions": [
            "Have the person sit down and rest.",
            "If the person has prescribed nitroglycerin, help them take it.",
            "Loosen any tight clothing around the neck.",
            "If the person has aspirin and is not allergic, help them chew and swallow one adult aspirin.",
            "https://youtu.be/6ZGg0zJUFEI?si=AHBPRoP61gs4eHsn",  # Moved video_link to the last
        ]
    },
    "stroke": {
        "description": "Disruption of blood flow to the brain.",
        "severity": 19,
        "actions": [
            "Note the time symptoms started.",
            "Have the person lie down with their head slightly elevated.",
            "Check for signs of facial drooping, arm weakness, or speech difficulties (FAST test).",
            "https://www.youtube.com/watch?v=PhH9a0kIwmk&pp=ygUcaG93IHRvIGZpcnN0IGFpZCB3aGVuIHN0cm9rZQ%3D%3D",  # Moved video_link to the last
        ]
    },
    "choking": {
        "description": "Blockage of the airway.",
        "severity": 17,
        "actions": [
            "Encourage the person to cough forcefully.",
            "If coughing fails, perform abdominal thrusts (Heimlich maneuver).",
            "For infants, perform back blows and chest thrusts.",
            "https://www.youtube.com/watch?v=pzlwOI7xQRc&pp=ygUdaG93IHRvIGZpcnN0IGFpZCB3aGVuIGNob2tpbmc%3D",  # Moved video_link to the last
        ]
    },
    "severe allergic reaction": {
        "description": "Life-threatening reaction to an allergen.",
        "severity": 20,
        "actions": [
            "If the person has an epinephrine auto-injector (EpiPen), help them administer it.",
            "Have the person lie down with their legs elevated.",
            "https://www.youtube.com/watch?v=0Q5npXJ8KUY&pp=ygUuaG93IHRvIGZpcnN0IGFpZCB3aGVuIHNldmVyZSBhbGxlcmdpYyByZWFjdGlvbg%3D%3D",  # Moved video_link to the last
        ]
    },
    "seizure": {
        "description": "Uncontrolled electrical disturbances in the brain.",
        "severity": 15,
        "actions": [
            "Protect the person from injury. Clear the area of hard or sharp objects.",
            "Do not try to restrain the person. Do not put anything in their mouth.",
            "Roll the person onto their side if they are vomiting or drooling.",
            "Time the seizure if possible.",
            "https://www.youtube.com/watch?v=V-74_D1Bn5Q&pp=ygUtaG93IHRvIGZpcnN0IGFpZCB3aGVuIHVuY29udHJvbGxhYmxlIHZvbWl0aW5n",  # Moved video_link to the last
        ]
    },
    "loss of consciousness": {
        "description": "A person is unresponsive and unaware of their surroundings.",
        "severity": 18,
        "actions": [
            "Check for breathing and pulse.",
            "If not breathing, start CPR if trained.",
            "Place the person in the recovery position if they are breathing.",
            "https://www.youtube.com/watch?v=ddHKwkMwNyI&pp=ygUraG93IHRvIGZpcnN0IGFpZCB3aGVuIGxvc3Mgb2YgY29uc2Npb3VzbmVzcw%3D%3D",  # Moved video_link to the last
        ]
    },
    "difficulty breathing": {
        "description": "Struggling to breathe or shortness of breath.",
        "severity": 13,
        "actions": [
            "Have the person sit in an upright position.",
            "Loosen any tight clothing.",
            "If the person has a prescribed inhaler, help them use it.",
            "If wheezing or suspected asthma attack, use a reliever inhaler if available.",
            "https://www.youtube.com/watch?v=hdVKpUR513M&pp=ygUqaG93IHRvIGZpcnN0IGFpZCB3aGVuIGRpZmZpY3VsdHkgYnJlYXRoaW5n",  # Moved video_link to the last
        ]
    },
    "head injury": {
        "description": "Trauma or injury to the head.",
        "severity": 16,
        "actions": [
            "Apply pressure to control any bleeding.",
            "Keep the person still and lying down with their head slightly elevated.",
            "Do not move the person if a neck or spine injury is suspected.",
            "https://www.youtube.com/watch?v=a4cIFZx1f2E&pp=ygUhaG93IHRvIGZpcnN0IGFpZCB3aGVuIGhlYWQgaW5qdXJ5",  # Moved video_link to the last
        ]
    },
    "spinal injury": {
        "description": "Damage to the spinal cord.",
        "severity": 20,
        "actions": [
            "Do not move the person unless absolutely necessary.",
            "Stabilize the neck and head to prevent further movement.",
            "https://www.youtube.com/watch?v=Uqy2IUhYkVA&pp=ygUjaG93IHRvIGZpcnN0IGFpZCB3aGVuIHNwaW5hbCBpbmp1cnk%3D",  # Moved video_link to the last
        ]
    },
    "suspected poisoning": {
        "description": "Exposure to a harmful substance.",
        "severity": 15,
        "actions": [
            "Identify the poison if possible.",
            "If the person is conscious, have them rinse their mouth if the poison was ingested.",
            "Contact a poison control center or emergency services for guidance.",
            "https://www.youtube.com/watch?v=b2ieb8BZJuY&pp=ygUpaG93IHRvIGZpcnN0IGFpZCB3aGVuIHN1c3BlY3RlZCBwb2lzb25pbmc%3D",  # Moved video_link to the last
        ]
    },
    "high fever": {
        "description": "Body temperature significantly above normal.",
        "severity": 12,
        "actions": [
            "Remove excess clothing or blankets.",
            "Cool the person with a lukewarm bath or shower.",
            "Encourage fluids to prevent dehydration.",
            "Consider over-the-counter fever reducers (acetaminophen, ibuprofen) if appropriate.",
            "https://www.youtube.com/watch?v=faLkXDXrhnM&pp=ygUgaG93IHRvIGZpcnN0IGFpZCB3aGVuIGhpZ2ggZmV2ZXI%3D",  # Moved video_link to the last
        ]
    },
    "chest pain": {
        "description": "Discomfort or pressure in the chest.",
        "severity": 17,
        "actions": [
            "Have the person sit down and rest.",
            "Loosen any tight clothing.",
            "If the person has prescribed nitroglycerin, help them take it.",
            "If the person has aspirin and is not allergic, help them chew and swallow one adult aspirin.",
            "https://www.youtube.com/watch?v=7y_9WF8r2gs&pp=ygUgaG93IHRvIGZpcnN0IGFpZCB3aGVuIGNoZXN0IHBhaW4%3D",  # Moved video_link to the last
        ]
    },
    "abdominal pain": {
        "description": "Pain or discomfort in the abdomen (stomach area).",
        "severity": 14,
        "actions": [
            "Have the person rest in a comfortable position.",
            "Do not give anything to eat or drink until evaluated by a medical professional.",
            "Monitor for worsening pain, vomiting, or fever.",
            "https://www.youtube.com/watch?v=cIZ2v2_ILMg&pp=ygUkaG93IHRvIGZpcnN0IGFpZCB3aGVuIGFiZG9taW5hbCBwYWlu",  # Moved video_link to the last
        ]
    },
    "sudden confusion": {
        "description": "Abrupt disorientation, difficulty thinking clearly, or changes in behavior.",
        "severity": 11,
        "actions": [
            "Try to determine the cause (e.g., check for signs of low blood sugar).",
            "Stay with the person and reassure them.",
            "Monitor for changes in condition.",
            "https://www.youtube.com/watch?v=6ZGg0zJUFEI&pp=ygUnaG93IHRvIGZpcnN0IGFpZCB3aGVuIHN1ZGRlbiBjb25mdXNpb24i",  # Moved video_link to the last
        ]
    },
}



def doComputation(text):
  doc = nlp(text)

  similarity_index = []
  for ent in doc.ents :
    for instruction in instructions:
      sentences = [str(ent),str(instruction)]

      model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')
      embedding_1 = model.encode(sentences[0], convert_to_tensor=True)
      embedding_2 = model.encode(sentences[1], convert_to_tensor=True)

      similarity = util.pytorch_cos_sim(embedding_1, embedding_2)
      temp = {
          "ent" : ent,
          "instruction" : instruction,
          "similarity" : similarity
      }
      similarity_index.append(temp)
  sorted_data = sorted(similarity_index, key=lambda x: x['similarity'], reverse=True)
  final_instructions = set()

  final_result = {}

  for ins_temp in sorted_data[0:1]:
    temp = (instructions[ins_temp["instruction"]])

    for action in temp["actions"]:
      final_instructions.add(action)

  return final_instructions




import json
from flask import Flask,request
from pyngrok import ngrok
ngrok.set_auth_token("2dRx9s4wTB4onm9aw4wy8tdJkwc_65hSZzSvdQ89EA1a4gUhW")

publicUrl = ngrok.connect(5000).public_url

print(publicUrl)
values=[]

app = Flask(_name_)

@app.route("/")
def home():
  return "Hello World!"

@app.route("/predict" , methods = ["POST"])
def prediction():
  data = request.json
  result = list(doComputation(data["transcript"]))
  return json.dumps(result)
  # result[0] = json.loads(result[0])
  # for i in result[0]:
  #   values.append(i.value)
  # print(values)
  # return values

app.run(host = "0.0.0.0" , port = 5000)