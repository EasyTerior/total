#!/D:/total/flaskrun/Scripts/python.exe
# 가상환경의 python을 통해 실행되도록 처리.
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

# model
import torch

# flask
from flask import Flask, request, jsonify, Response, redirect, url_for
from flask_cors import CORS


# debug
import traceback

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

print("sys.executable : "+sys.executable)

# Flask
app = Flask(__name__)
handler = logging.FileHandler('flask.log')  # 로그 파일 경로
app.logger.setLevel(logging.ERROR) # (logging.DEBUG)
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
app.logger.addHandler(handler)

CORS(app)
UPLOAD_FOLDER = 'D:/total/easyTerior_total/src/main/webapp/resources/images/flask/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
FLASK_IMAGE = 'D:/total/flask/images/'
app.config['FLASK_IMAGE'] = FLASK_IMAGE

# 확장자 안 바꿀 때,
def fileRename(oldfile, name):
    original_filename = os.path.basename(oldfile)
    filename, extension = os.path.splitext(original_filename)
    print("original_filename : ", original_filename)
    print("filename : ",filename," | extension : ", extension)
    print("fileRename called Result : ", (filename + name + extension))
    return filename + name + extension

# 확장자 변경 시,
def fileRename(oldfile, name, ext):
    original_filename = os.path.basename(oldfile)
    filename, extension = os.path.splitext(original_filename)
    print("original_filename : ", original_filename)
    print("filename : ",filename," | extension : ", extension)
    print("fileRename called Result : ", (filename + name + "." + ext))
    return filename + name + "."+ ext



@app.route('/process_image', methods=['POST'])
def process_image():
    try:
        # 요청에서 newFilePath와 csrfToken 가져오기
        origin_path = request.form.get('newFilePath')
        image_path = request.form.get('newFilePath') # 사용자가 업로드 한 이미지 경로로 가져온 이미지
        csrf_token = request.form.get('csrfToken')

        # 이미지 파일 읽기
        image_file = open(image_path, 'rb')

        # 업로드된 이미지 읽기
        image = cv2.imread(image_path)

        # 객체 탐지 로직 구현
        # TODO: 이미지 처리 및 객체 탐지 코드 작성

        # Read the image using OpenCV
        nparr = np.frombuffer(image_file.read(), np.uint8)
        image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        # Halve the size of the image
        resized_image = cv2.resize(image, None, fx=1, fy=1)

        # Save the resized image to the specified directory with '_resized'and .jpg in file name
        new_filename = fileRename(image_path, "_resized", "jpg")
        print("_resized image created\nnew_filename : "+new_filename)

        # 새롭게 저장할 경로
        save_path = os.path.join(app.config['FLASK_IMAGE'], new_filename)
        cv2.imwrite(save_path, resized_image)
        print("save_path : ", save_path)

        script = "D:/total/yolov5/segment/predict.py"
        bestPt = "D:/total/yolov5/myBest.pt"
        args = ["--weights", bestPt, "--img", "736", "--conf", "0.2", "--source", save_path, "--retina-masks", "--save-txt"]

        # 가상환경의 파이썬 실행 파일 경로
        python_executable = "D:/total/flaskrun/Scripts/python.exe"

        # script_result  = 
        subprocess.run([python_executable, script] + args, capture_output=True, text=True)
        # print("script_result :",script_result)

        folder_path = "D:/total/yolov5/runs/predict-seg/"  # 기존 폴더 경로
        exp_prefix = "exp"

        # exp 폴더에서 가장 큰 숫자를 찾기
        exp_folders = [f for f in os.listdir(folder_path) if os.path.isdir(os.path.join(folder_path, f)) and f.startswith(exp_prefix)]
        latest_exp_folder = max(exp_folders, key=lambda x: int(x[len(exp_prefix):]) if x[len(exp_prefix):].isdigit() else -1)
        label_path = "labels/"+new_filename.split('.')[0]+".txt"


        if latest_exp_folder:
            # 파일 경로 생성
            file_path = os.path.join(folder_path, latest_exp_folder, label_path)
            file_path = file_path.replace("\\", "/")
            print("file_path for label txt :", file_path)

            # Check if the file exists
            if not os.path.exists(file_path):
                # 파일이 존재하지 않는 경우, JSP로 JSON 응답 반환
                print('파일이 존재하지 않는 경우, JSP로 JSON 응답 반환')
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
            # Add more class-color mappings as needed
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
        # output_image를 D:/total/flask/images에 저장
        output_filename = fileRename(save_path.split('/')[-1], "_processed", "jpg")

        cv2.imwrite(UPLOAD_FOLDER+output_filename, output_image) # UPLOAD_FOLDER에 _processed 추가하여 생성.
        print('UPLOAD_FOLDER+output_filename :', UPLOAD_FOLDER+output_filename)

        # Convert the list of detected object IDs to a JSON string
        detected_object_ids_json = json.dumps(detected_object_ids, ensure_ascii=False).encode('utf-8')
        # Redirect to the colorSelect.do URL

        # Flask에서 JSP로 JSON 데이터 전송
        print('Flask에서 JSP로 JSON 데이터 전송 : detected_object_ids_json 전송 예정')
        print('detected_object_ids_json :', detected_object_ids_json)

        # 보낼 이미지 경로 exp 폴더 안의 resized 된 jpg 경로를 전달
        # 이미지 파일의 확장자
        image_extension = '.jpg'

        # latest_exp_folder에서 .jpg 이미지 파일을 찾아서 경로를 가져옴
        image_folder = os.path.join(folder_path, latest_exp_folder)
        image_files = [f for f in os.listdir(image_folder) if f.lower().endswith(image_extension)]
        if len(image_files) > 0:
            # .jpg 이미지가 존재하는 경우, 첫 번째 이미지 파일의 경로를 new_img_path에 저장
            new_img_path = image_folder+'/'+image_files[0] # predict-seg/exp21\_temp_.jpg 이렇게 나옴
            print('new_img_path :', new_img_path)
        else:
            # .jpg 이미지가 존재하지 않는 경우, 에러 처리 등을 수행
            new_img_path = None
            print('resized 이미지 파일이 존재하지 않는 경우, JSP로 JSON 응답 반환')

        # new_img_path를 URL로 인코딩하여 전달
        if new_img_path:
            # detected_object_ids_json과 new_img_path를 URL로 인코딩
            encoded_detection_result = urllib.parse.quote(detected_object_ids_json)
            encoded_img_path = urllib.parse.quote(new_img_path)

            # 인코딩된 값을 쿼리 파라미터로 전달
            redirect_url = f'http://localhost:8081/colorSelect.do?detection_result={encoded_detection_result}&img_path={encoded_img_path}&image_folder={image_folder}'
            # print('\n\nprocess_image successfully Done\n\n')
            return redirect_url
        else:
            # print('\n\nprocess_image Image not found Return\n\n')
            return 'http://localhost:8081/colorChange.do?message=Image not found'

    except Exception as e:
        app.logger.error("Error processing image: %s", str(e))
        app.logger.error(traceback.format_exc())  # Traceback 정보 기록
        print("Error processing image :", str(e))
        return jsonify({'error': 'Failed to process image'}), 500

@app.route('/color_change', methods=['POST'])
def color_change():
    print('\n\ncolor_change called')
    try:
         # 요청에서 가져오기
        csrfToken = request.form.get('csrfToken')
        originalImg = request.form.get('originalImg') # 사용자가 업로드 한 이미지 경로로 가져온 이미지
        selectedObjectList = request.form.get('selectedObjectList') # 사용자가 선택한 객체 목록
        selectedColorValue = request.form.get('selectedColorValue') # 사용자가 선택한 색깔 r,g,b 값
        imageDir = request.form.get('imageDir') # flask 에서 작업했던 exp 경로
        print(f'csrfToken : {csrfToken}\noriginalImg : {originalImg} | {type(originalImg)}\nselectedObjectList : {selectedObjectList} | type : {type(selectedObjectList)}\nselectedColorValue : {selectedColorValue} | type : {type(selectedColorValue)}\nimageDir : {imageDir} | type : {type(imageDir)}\n')

        dict_rgb = json.loads(selectedColorValue)

        folder_path = "D:/id57176422/yolov5/runs/predict-seg/"  # 기존 폴더 경로
        exp_prefix = "exp"
        # 이미지 읽기
        label_path = os.path.join(imageDir, "labels/processed_image.txt")
        label_path = label_path.replace("\\", "/")

        with open(label_path, 'r') as file:
                content = file.read().splitlines()  # Remove newline characters
        # lines = content.split('\n')
        img_path = originalImg
        image = cv2.imread(img_path)

        coordinates_dict = {}
        for line in content:
            line_number, *coordinates = line.split(' ')
            if line_number.isdigit() and line_number in selectedObjectList:
                if line_number in coordinates_dict:
                    coordinates_dict[line_number].append(coordinates)
                else:
                    coordinates_dict[line_number] = [coordinates]
        # 좌표 출력 - 가져온 RGB 적용
        for item in selectedObjectList:
            if item in coordinates_dict:
                coordinates_list = coordinates_dict[item]
                print(f"{item} 좌표:")
                for coordinates in coordinates_list:
                    print(coordinates)
            else:
                print(f"{item}에 대한 좌표가 없습니다.")
        
        # 좌표에 색상 적용 - 색깔 칠하기
        for item in selectedObjectList:
            if item in coordinates_dict:
                coordinates_list = coordinates_dict[item]
                for coordinates in coordinates_list:
                    pixel_coordinates = []
                    for i in range(0, len(coordinates), 2):
                        x = float(coordinates[i])
                        y = float(coordinates[i+1])
                        x_pixel = int(x * image.shape[1])
                        y_pixel = int(y * image.shape[0])
                        pixel_coordinates.append((x_pixel, y_pixel))
                    
                # Convert pixel coordinates to NumPy array
                polygon_coordinates = np.array([pixel_coordinates], dtype=np.int32)

                # BGR을 HSV로 변환
                # bgr_color=bgr_color[::-1]
                hsv_color = cv2.cvtColor(np.uint8([[bgr_color]]), cv2.COLOR_BGR2HSV)
                hsv_color = hsv_color[0][0]

                # hue
                hue=hsv_color[0]
                saturation=hsv_color[1]

                # Create a mask for the polygon
                mask = np.zeros(image.shape[:2], dtype=np.uint8)
                cv2.fillPoly(mask, polygon_coordinates, 255)

                # Convert the original image to HSV
                hsv_image = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

                # Change the hue of the masked area
                hsv_image[mask == 255, 0] = hue #0 이라 한 이유는 마스크된 영역내의 모든 픽셀의 Hue(색조) 채널을 가리킴
                hsv_image[mask == 255, 1] = saturation #1이라 한 이유는  마스크된 영역내의 모든 픽셀의 saturation(채도) 을 가리킴
                #hsv_image[mask == 255,2] = value #2이라 한 이유는 마스크된 영역내의 모든 픽셀의 value(명도)를 가리킴 

                # Convert the image back to BGR
                image = cv2.cvtColor(hsv_image, cv2.COLOR_HSV2BGR)

                #Hue(색조): 0에서 179까지의 범위를 갖습니다. 이 값은 색상의 종류를 나타냅니다. 예를 들어, 0은 빨간색에 해당하고, 60은 녹색에 해당합니다. 180은 다시 빨간색에 가까워지는 값입니다.
                #Saturation(채도): 0에서 255까지의 범위를 갖습니다. 이 값은 색의 순수성 또는 탁하게 보이는 정도를 나타냅니다. 0은 무채색(흰색, 회색)에 해당하고, 255는 가장 높은 채도를 나타냅니다.
                #Value(명도): 0에서 255까지의 범위를 갖습니다. 이 값은 색의 밝기를 나타냅니다. 0은 검은색에 해당하고, 255는 가장 밝은 색에 해당합니다.
    except Exception as e:
        app.logger.error("Error color_change image: %s", str(e))
        app.logger.error(traceback.format_exc())  # Traceback 정보 기록
        print("Error color_change image :", str(e))
        return jsonify({'error': 'Failed to process image'}), 500



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
