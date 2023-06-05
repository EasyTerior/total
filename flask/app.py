# common
import os
import sys
import json
import requests
import subprocess
import urllib.parse

# Data Manipuliation
import numpy as np
import pandas as pd

# File I/O
import base64
from io import BytesIO

#DB
from sqlalchemy import create_engine

# image process, model
import cv2
import numpy as np
from PIL import Image
from IPython.display import Image, display

# flask
from flask import Flask, request, send_file, send_from_directory, redirect, jsonify
from flask_cors import CORS, cross_origin


# DB - MySQL Connection
engine = create_engine('mysql+pymysql://seocho_0515_2:smhrd2@project-db-stu.smhrd.com:3307/seocho_0515_2?charset=utf8', echo = False)

# buffer = BytesIO()
# img_path = 'D:/total/images/'
# img_file = 'person.jpg' # png -> KeyError: 'P'
# im = Image.open(img_path+img_file)

def readImage():
    member_df = pd.read_sql(sql='SELECT * FROM member', con=engine)
    img_df = pd.read_sql(sql='SELECT * FROM images WHERE', con=engine)

    img_str = img_df['image_data'].values[0]
    # print(type(img_str)) # data type이 'byte'이다.

    img = base64.decodestring(img_str)

    im = Image.open(BytesIO(img))
    im.show()


# Flask
app = Flask(__name__)
CORS(app)
UPLOAD_FOLDER = 'D:/total/src/main/webapp/resources/images/flask/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

bgr_color=None
selected_items= []
selected_items_labels=[]

@app.route('/process_image', method=['POST'])
def process_image():
    # Check if an 'image' file was included in the request
    if 'image' not in request.files:
        return "No 'image' file included in request.", 400
    else:
        # Get the uploaded image file
        image_file = request.files['image']
        # Get the filename
        filename = os.path.basename(image_file.filename)

        # Read the image using OpenCV
        nparr = np.frombuffer(image_file.read(), np.uint8)
        image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        # Halve the size of the image
        resized_image = cv2.resize(image, None, fx=1, fy=1)

        # Save the resized image to the specified directory
        img_path = os.path.join(app.config['UPLOAD_FOLDER'], 'processed_'+filename)
        cv2.imwrite(img_path, resized_image)

        script = "yolov5/segment/predict.py"
        args = ["--weights", "best.pt", "--img", "736", "--conf", "0.2", "--source", img_path, "--retina-masks", "--save-txt"]

        result = subprocess.run(["python", script] + args, capture_output=True, text=True)

        folder_path = "D:/total/yolov5/runs/predict-seg/"  # 기존 폴더 경로
        exp_prefix = "exp"

        # exp 폴더에서 가장 큰 숫자를 찾기
        exp_folders = [f for f in os.listdir(folder_path) if os.path.isdir(os.path.join(folder_path, f)) and f.startswith(exp_prefix)]
        latest_exp_folder = max(exp_folders, key=lambda x: int(x[len(exp_prefix):]) if x[len(exp_prefix):].isdigit() else -1)

        if latest_exp_folder:
            # 파일 경로 생성
            file_path = os.path.join(folder_path, latest_exp_folder, "labels/processed_image.txt")

            # Check if the file exists
            if not os.path.isfile(file_path):
                return redirect('http://localhost:8081/colorChange.do?message=' + urllib.parse.quote('Image not detected'))
            else:
                with open(file_path, 'r') as file:
                    lines = file.read().splitlines()  # Remove newline characters

    # Create a list to store the detected object IDs
    detected_object_ids = []
    #Create a mask image with the same shape as the original image
    mask = np.zeros_like(image)

    # Define color mappings for different classes
    class_colors = {
        0:(0,0,0), #침대
        1:(0,0,0), #이불
        2:(0,0,0), #카펫
        3:(0,0,0), #의자
        4:(0, 0, 0),  # 커튼
        5:(0, 0, 0), #문
        6:(0, 0, 0), #램프
        7:(0, 0, 0), # 베개
        8:(0, 0, 0), #선반
        9:(0, 0, 0), #소파
        10:(0, 0, 0), #테이블
        #Add more class-color mappings as needed
    }

    # Iterate over the coordinates in reverse order and draw filled polygons on the mask image
    for line in reversed(lines):
        values = line.strip().split()
        class_id = int(values[0])
        class_coordinates = [(float(values[i]), float(values[i+1])) for i in range(1, len(values), 2)]
        detected_object_ids.append(class_id)
        # Convert normalized coordinates to pixel coordinates
        pixel_coordinates = []
        for x, y in class_coordinates:
            x_pixel = int(x * image.shape[1])
            y_pixel = int(y * image.shape[0])
            pixel_coordinates.append((x_pixel, y_pixel))

        # Convert pixel coordinates to NumPy array
        polygon_coordinates = np.array([pixel_coordinates], dtype=np.int32)

        # Get the color for the current class ID
        color = class_colors.get(class_id, (0, 0, 0))  # Default to black color if class ID is not mapped

        # Draw filled polygon on the mask image
        cv2.fillPoly(mask, polygon_coordinates, color)

    # Invert the mask to select the non-object regions
    inverted_mask = cv2.bitwise_not(mask)

    # Extract the non-object regions from the original image using the inverted mask
    non_object_regions = cv2.bitwise_and(image, inverted_mask)

    # Combine the non-object regions and the mask
    output_image = cv2.bitwise_or(mask, non_object_regions)

    # Save the modified image
    cv2.imwrite(img_path, output_image)

     # Convert the list of detected object IDs to a JSON string
    detected_object_ids_json = json.dumps(detected_object_ids)
    # Redirect to the colorSelect.do URL
    redirect_url = "http://localhost:8081/colorSelect.do?detected_object_ids=" + detected_object_ids_json
    return redirect(redirect_url)


if __name__ == '__main__':
    app.run()



