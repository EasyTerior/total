# common
import os
import sys
import json
import requests
import subprocess
import urllib.parse

# Data Manipulation
import numpy as np
import pandas as pd

# File I/O
import base64
from io import BytesIO

# DB
from sqlalchemy import create_engine

# image process, model
import cv2
from PIL import Image
from IPython.display import Image as IPImage, display

# flask
from flask import Flask, request, jsonify, Response, redirect
from flask_cors import CORS

# DB - MySQL Connection
engine = create_engine('mysql+pymysql://seocho_0515_2:smhrd2@project-db-stu.smhrd.com:3307/seocho_0515_2?charset=utf8', echo=False)

def readImage():
    member_df = pd.read_sql(sql='SELECT * FROM member', con=engine)
    img_df = pd.read_sql(sql='SELECT * FROM images WHERE', con=engine)

    img_str = img_df['image_data'].values[0]
    # print(type(img_str)) # data type이 'byte'이다.

    img = base64.decodestring(img_str)

    im = Image.open(BytesIO(img))
    im.show()

import datetime
# 현재 시간을 UTC로 가져오기
current_time = datetime.datetime.utcnow()

# 한국 표준시와의 시차 (UTC+9)를 적용하여 한국의 현재 시간 계산
korea_time = current_time + datetime.timedelta(hours=9)
print("Hello flask! Now : ", korea_time)

import logging
from logging.handlers import RotatingFileHandler

# Flask
app = Flask(__name__)

app.logger.setLevel(logging.DEBUG)
handler = RotatingFileHandler('flask.log', maxBytes=100000, backupCount=1)
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
app.logger.addHandler(handler)

CORS(app)
UPLOAD_FOLDER = 'D:/total/src/main/webapp/resources/images/flask/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/process_image', methods=['POST'])
def process_image():
    try:
        # 요청에서 newFilePath와 csrfToken 가져오기
        image_path = request.form.get('newFilePath')
        csrf_token = request.form.get('csrfToken')

        # 이미지 파일 읽기
        with open(image_path, 'rb') as f:
            image_file = f.read()

        # 업로드된 이미지 읽기
        image_cv = cv2.imread(image_path)

        # 이미지를 PIL 이미지로 변환
        # image_pil = Image.fromarray(cv2.cvtColor(image_cv, cv2.COLOR_BGR2RGB))

        # PIL 이미지를 화면에 표시
        # display(image_pil)

        # 객체 탐지 로직 구현
        # TODO: 이미지 처리 및 객체 탐지 코드 작성
        # Read the image using OpenCV
        nparr = np.frombuffer(image_file.read(), np.uint8)
        image_cv = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        # Halve the size of the image
        resized_image = cv2.resize(image_cv, None, fx=1, fy=1)

        # Save the resized image to the specified directory with '_resized' in file name
        original_filename = os.path.basename(image_path)
        filename, extension = os.path.splitext(original_filename)
        new_filename = filename + "_resized" + extension
        save_path = os.path.join(app.config['UPLOAD_FOLDER'], new_filename)
        cv2.imwrite(save_path, resized_image)

        
        script = "D:/total/yolov5/segment/predict.py"
        args = ["--weights", "best.pt", "--img", "736", "--conf", "0.2", "--source", save_path, "--retina-masks", "--save-txt"]

        script_result  = subprocess.run(["python", script] + args, capture_output=True, text=True)

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

        
        #processed_img_path = 
        # 결과 반환 예시
        result = {
            'message': '이미지 처리 결과',
            'data': {
                'objects': ['object1', 'object2', 'object3'],  # 객체 탐지 결과 리스트 예시
                'confidence': [0.8, 0.6, 0.9],  # 신뢰도 예시
                'origin_img' : new_file_path,
                # 'processed_img' : processed_img_path,
            }
        }
        print("result : \n", result)
         # JSON 형태로 결과 반환
        json_result = json.dumps(result, ensure_ascii=False).encode('utf-8')
        return Response(json_result, content_type='application/json; charset=utf-8')

        # # JSP 파일로 POST 요청 보내기
        # url = 'http://localhost:8081/colorSelect.do'
        # response = requests.post(url, json=result)

        # # 응답 처리
        # if response.status_code == 200:
        #     # JSON 응답 파싱
        #     result = response.json()
        #     print('Flask에서 요청 성공')
        #     # # 변수에 저장
        #     # jsonResponse = json.dumps(result)
        #     # JSP 파일로 리다이렉트 수행
        #     redirect_url = "http://localhost:8081/imageSelect.do"
        #     return redirect(redirect_url + "?result=" + json.dumps(result))
        #     # return "redirect:/imageSelect.do"  # JSP 파일로 리다이렉트

        # else:
        #     print('Flask에서 요청 실패')
        # return jsonify(result), 200
        # 리다이렉트를 수행하도록 JSP로 응답 반환
        # return redirect('/colorSelect.do')

    except Exception as e:
        print("Error processing image:", str(e))
        return jsonify({'error': 'Failed to process image'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
