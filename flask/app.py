# #!/D:/total/flaskrun/Scripts/python.exe
# 가상환경의 python을 통해 실행되도록 처리.
# common
import os
import re
import sys
import json
import requests
import subprocess
import urllib
import urllib.parse
import configparser

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

# torch
import torch

# tensorflow
from tensorflow.keras.preprocessing.image import load_img, img_to_array
from tensorflow.keras.models import load_model
from tensorflow.keras.applications.vgg16 import preprocess_input

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
# UPLOAD_FOLDER = 'C:/total/easyTerior_total/src/main/webapp/resources/images/flask/'
UPLOAD_FOLDER = 'D:/total/easyTerior_total/src/main/webapp/resources/images/flask/'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
FLASK_IMAGE = 'D:/total/flask/images/'
# FLASK_IMAGE = 'C:/total/flask/images/'
app.config['FLASK_IMAGE'] = FLASK_IMAGE


# NAVER API search
client_id = "YmwEYBDY7aXnrocNn5Zx"
client_secret = "0daNsnl46p"

# tensorflow 모델 불러오기
tensor_model = load_model("D:/total/tensorflow/89216(ver8,flip).h5")


# 확장자 변경 시,
def fileRename(oldfile, name, ext):
    original_filename = os.path.basename(oldfile)
    filename, extension = os.path.splitext(original_filename)
    # print("original_filename : ", original_filename)
    # print("filename : ",filename," | extension : ", ext)
    print("fileRename called Result : ", (filename + name + "." + ext))
    return filename + name + "."+ ext


# 확장자 안 바꿀 때,
def fileRenameNoExt(oldfile, name):
    print('fileRenameNoExt')
    original_filename = os.path.basename(oldfile)
    filename, extension = os.path.splitext(original_filename)
    # print("original_filename : ", original_filename)
    # print("filename : ",filename," | extension : ", extension)
    print("fileRename called Result : ", (filename + name + extension))
    return filename + name + extension


# 객체 레이블
def get_object_label(object_id):
    switcher = {
        0: "침대",
        1: "이불",
        2: "카펫",
        3: "의자",
        4: "커튼",
        5: "문",
        6: "램프",
        7: "베개",
        8: "선반",
        9: "소파",
        10: "테이블"
    }
    return switcher.get(object_id, "알 수 없음")


# 색깔 정의
def closest_color(rgb):
    colors = {"빨간색": [0, 0, 255], "주황색": [0, 165, 255], "노랑색": [0, 255, 255], "초록색": [0, 255, 0], "파란색": [255, 0, 0], "남색": [255, 0, 255], "보라색": [238, 130, 238], "흰색": [255, 255, 255], "검은색": [0, 0, 0]}

    closest_name = None
    closest_distance = None  # Use 'closest_distance' instead of 'closest_color'
    for name, color in colors.items():
        distance = np.linalg.norm(np.array(color) - np.array(rgb))
        if closest_distance is None or distance < closest_distance:
            closest_distance = distance
            closest_name = name

    return closest_name


@app.route('/process_image', methods=['POST'])
def process_image():
    from flask import request # request 객체를 참조하기 전에 request 변수를 선언하고 초기화
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

        # Read the image using OpenCV
        nparr = np.frombuffer(image_file.read(), np.uint8)
        image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

        # Halve the size of the image
        resized_image = cv2.resize(image, None, fx=1, fy=1)

        # Save the resized image to the specified directory with '_resized'and .jpg in file name
        new_filename = fileRename(image_path, "_resized", "jpg")
        print("\n\n_resized image created\nnew_filename : "+new_filename)

        # 새롭게 저장할 경로
        save_path = os.path.join(app.config['FLASK_IMAGE'], new_filename)
        cv2.imwrite(save_path, resized_image)
        print("save_path : ", save_path)

        # script = "C:/total/yolov5/segment/predict.py"
        # bestPt = "C:/total/yolov5/myBest.pt"
        script = "D:/total/yolov5/segment/predict.py"
        bestPt = "D:/total/yolov5/myBest.pt"
        args = ["--weights", bestPt, "--img", "736", "--conf", "0.2", "--source", save_path, "--retina-masks", "--save-txt"]

        # 가상환경의 파이썬 실행 파일 경로
        python_executable = "D:/total/flaskrun/Scripts/python.exe"
        # python_executable = "C:/venvs/flaskrun/Scripts/python.exe"

        # script_result  =
        subprocess.run([python_executable, script] + args, capture_output=True, text=True)
        # print("script_result :",script_result)

        # folder_path = "C:/total/yolov5/runs/predict-seg/"
        folder_path = "D:/total/yolov5/runs/predict-seg/"  # 기존 폴더 경로
        exp_prefix = "exp"

        # exp 폴더에서 가장 큰 숫자를 찾기
        exp_folders = [f for f in os.listdir(folder_path) if os.path.isdir(os.path.join(folder_path, f)) and f.startswith(exp_prefix)]
        latest_exp_folder = max(exp_folders, key=lambda x: int(x[len(exp_prefix):]) if x[len(exp_prefix):].isdigit() else -1)
        label_path = "labels/"+new_filename.split('.')[0]+".txt"
        print(f'label_path : {label_path}')

        if latest_exp_folder:
            # 파일 경로 생성
            file_path = os.path.join(folder_path, latest_exp_folder, label_path)
            file_path = file_path
            print("file_path for label txt :", file_path)

            # Check if the file exists
            if not os.path.exists(file_path):
                # 파일이 존재하지 않는 경우, JSP로 JSON 응답 반환
                print('file_path 파일이 존재하지 않는 경우, JSP로 JSON 응답 반환')
                return redirect('http://localhost:8081/colorChange.do?message=' + urllib.parse.quote('Image not detected'))

            with open(file_path, 'r') as file:
                lines = file.read().splitlines()  # Remove newline characters

        # Create a list to store the detected object IDs
        detected_object_ids = []
        #Create a mask image with the same shape as the original image
        mask = np.zeros_like(image)

        # Define color mappings for different classes
        class_colors = {
            0:(0,0,0), # 침대
            1:(0,0,0), # 이불
            2:(0,0,0), # 카펫
            3:(0,0,0), # 의자
            4:(0, 0, 0), # 커튼
            5:(0, 0, 0), # 문
            6:(0, 0, 0), # 램프
            7:(0, 0, 0), # 베개, 쿠션
            8:(0, 0, 0), # 선반
            9:(0, 0, 0), # 소파
            10:(0, 0, 0), # 테이블
            # Add more class-color mappings as needed
        }

        # 소파나 침대 등이 아래로 가도록 역순으로 읽음. layer을 역으로 쌓은 셈.
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
            print('\n\nprocess_image successfully Done\n\n')
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
    print('\n\ncolor_change called\n\n')
    # 2023-06-11 20:54:40,152 - ERROR - Error color_change image: local variable 'request' referenced before assignment
    # 2023-06-11 20:54:40,154 - ERROR - Traceback (most recent call last):
    # File "C:\total\flask\app.py", line 295, in color_change
    #     csrfToken = request.form.get('csrfToken')
    # UnboundLocalError: local variable 'request' referenced before assignment
    # 위 에러에 대해 아래에 새로 import 처리
    from flask import request # request 객체를 참조하기 전에 request 변수를 선언하고 초기화
    try:
        # 요청에서 가져오기
        csrfToken = request.form.get('csrfToken')
        originalImg = request.form.get('originalImg')  # 사용자가 업로드 한 이미지 경로로 가져온 이미지
        detectionResult = request.form.get('detectionResult') # 검출된 전체 객체 목록
        detectionResult = detectionResult.replace('[', '').replace(']', '').replace(' ', '').split(',')
        detectionResult = [num for num in detectionResult]
        selectedObjectList = request.form.getlist('selectedObjectList')  # 사용자가 선택한 객체 목록
        selectedColorValue = request.form.get('selectedColorValue')  # 사용자가 선택한 색깔 r,g,b 값
        dict_rgb = json.loads(selectedColorValue)
        imageDir = request.form.get('imageDir') # flask 에서 작업했던 exp 경로


        print(f'csrfToken : {csrfToken}\noriginalImg : {originalImg} | {type(originalImg)}\nselectedObjectList : {selectedObjectList} | type : {type(selectedObjectList)}\nselectedColorValue : {selectedColorValue} | type : {type(selectedColorValue)}\ndict_rgb : {dict_rgb} | type : {type(dict_rgb)}\nimageDir : {imageDir} | type : {type(imageDir)}\ndetectionResult : {detectionResult} | type : {type(detectionResult)}\n')

        r = dict_rgb['R']
        g = dict_rgb['G']
        b = dict_rgb['B']
        bgr_color = (b, g, r)
        print(f'bgr_color : {bgr_color} | type : {type(bgr_color)}\n')

        # folder_path = "C:/total/yolov5/runs/predict-seg/"
        folder_path = "D:/total/yolov5/runs/predict-seg/"  # 기존 폴더 경로
        exp_prefix = "exp"
        # 이미지 읽기
        label_dir = imageDir+"/labels/"
        label_path = [filename for filename in os.listdir(label_dir) if filename.endswith('.txt')]
        # print(f'before label_path : {label_path}')
        label_path = os.path.join(label_dir, label_path[0])
        label_path = label_path
        # print(f'after label_path : {label_path}') # 좌표 다 나옴 확인

        with open(label_path, 'r') as file:
            content = file.read()# .splitlines()  # Remove newline characters
        lines = content.split('\n')
        img_path = originalImg
        img_path = "/".join(img_path.split("\\"))
        img_path = img_path.replace("\a","/a").replace("\b","/b").replace("\f","/f").replace("\n","/n").replace("\r","/r").replace("\t","/t").replace("\v","/v")
        image = cv2.imread(img_path)
        print(f'orignal image path : {img_path} | \n\n')

        coordinates_dict = {}
        for line in lines: # 역순 필요 여부 체크
            line_number, *coordinates = line.split(' ')
            if line_number.isdigit() and line_number in detectionResult:
                if line_number in coordinates_dict:
                    coordinates_dict[line_number].append(coordinates)
                else:
                    coordinates_dict[line_number] = [coordinates]
        # 좌표 출력 - 가져온 RGB 적용
        for item in detectionResult:
            if item in coordinates_dict:
                coordinates_list = coordinates_dict[item]
                # print(f"{item} 좌표:")
                # for coordinates in coordinates_list:
                    # print(coordinates)
            else:
                print(f"{item}에 대한 좌표가 없습니다.")

        # 좌표에 색상 적용 - 색깔 칠하기
        for item in detectionResult:
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
        final_img_name = fileRename(img_path, "_final", "jpg")
        final_img = "/".join(img_path.split("/")[:-1]) + "/" +final_img_name
        # os.path.join("/".join(img_path.split("/")[:-1]), final_img_name)
        # final_img = "/".join(final_img.split("/")[:-1])+final_img
        print(f'\n\nBefore cv2.imwrite final image - img_path : {img_path} | final_img : {final_img}')
        cv2.imwrite(final_img, image)

        bgr_color__json = json.dumps(bgr_color)
        print(bgr_color__json)

        encoded_json = urllib.parse.quote(bgr_color__json)  # URL encoding
        print(f'encoded_json : {encoded_json}')

        real_color=closest_color(bgr_color)
        print(real_color)
        print(selectedObjectList)


        # Naver 쇼핑 API 결과 적용

        # configparser 객체 생성
        config = configparser.ConfigParser()
        # config.ini 파일 읽기
        config.read('config.ini')

        # 값 가져오기
        # client_id = config.get('Credentials', 'client_id')
        # client_secret = config.get('Credentials', 'client_secret')
        # 전역으로 뺌
        # client_id = "YmwEYBDY7aXnrocNn5Zx"
        # client_secret = "0daNsnl46p"
        print(f'client_id : {client_id} | client_secret : {client_secret}')
        # 중복성을 제거합니다. 최대 크기 제한은 제거했습니다.
        # selected_items_labels = list(set(selected_items_labels))
        selected_items_labels = [get_object_label(int(ids)) for ids in selectedObjectList]
        print(f'selected_items_labels : {selected_items_labels}')
        all_image_urls = []

        for label in selected_items_labels:
            encText = urllib.parse.quote(label)
            url = "https://openapi.naver.com/v1/search/image?query=" + encText
            req = urllib.request.Request(url)
            req.add_header("X-Naver-Client-Id",client_id)
            req.add_header("X-Naver-Client-Secret",client_secret)
            response = urllib.request.urlopen(req)
            rescode = response.getcode()

            if(rescode==200):
                response_body = response.read()
                response_dict = json.loads(response_body.decode('utf-8'))
                # 리스트의 크기에 따라 이미지를 가져오는 개수를 조정합니다.
                if len(selected_items_labels) <= 3:
                    image_urls = ",".join([urllib.parse.quote(item['link']) for item in response_dict['items'][:2]]) if response_dict['items'] else ""
                else:
                    image_urls = urllib.parse.quote(response_dict['items'][0]['link']) if response_dict['items'] else ""
                all_image_urls.append(image_urls)
            else:
                print("Error Code:" + rescode)
        # 모든 이미지 URL을 쉼표 띄어쓰기 로 구분하여 합칩니다.
        all_image_urls_str = ", ".join(all_image_urls)
        final_img
        print(f'encoded_json : {encoded_json}\nall_image_urls_str : {all_image_urls_str}\nfinal_img : {final_img}\noriginalImg : {originalImg}\nreal_color : {real_color}\n')

        redirect_url = "http://localhost:8081/colorChangeShowSave.do?img_data=" + encoded_json + "&naver_urls=" + all_image_urls_str + "&final_img="+final_img + "&original_img=" + originalImg+"&real_color="+real_color

        return redirect_url # redirect(redirect_url)

    except Exception as e:
        app.logger.error("Error color_change image: %s", str(e))
        app.logger.error(traceback.format_exc())  # Traceback 정보 기록
        print("Error color_change image :", str(e))
        return jsonify({'error': 'Failed to process image'}), 500



# 스타일 분석
@app.route("/call_api", methods=["POST"])
def call_api():
    from flask import request # request 객체를 참조하기 전에 request 변수를 선언하고 초기화
    data = request.json
    print(data)
    style = data.get("style") # {"style": "모던"}
    print(style)

    class_Explanation={
        '모던':'형태적으로는 번잡한 장식 없이 직선적인 디자인으로 깨끗하고 간결한 기능미를 느낄 수 있다. 색채요소로서는 무채색 혹은 단일한 강조색이 사용되며, 강렬한 명암대비 등의 특징을 가진다. 재료로는 금속, 유리 등 딱딱하고 차가운 소재가 활용된다. 기능적이고, 합리적인 깔끔한 이미지를 준다.',
        '캐주얼':'큰 무늬의 체크, 스트라이프, 동물 모티브의 무늬 등 독특한 무늬가 활 용된다. 색채요소로는 2-3가지의 다양한 색상 기준으로 다채로운 색상 이 활용된다. 재료로는 플라스틱, 패브릭 등의 가벼운 소재가 활용된다. 단순하고 젊고 경쾌한 분위기를 연출한다.',
        '내추럴':'자연을 떠올리게 하는 식물무늬 혹은 체크무늬 등이 활용된다. 색채요 소로는 자연에서 보기 쉬운 녹색계열, 아이보리계열 이 활용된다. 재료로는 목재, 흙, 돌 등이 활용된다. 목재 결 등 부재의 자연적 형태와 특 성이 잘 드러나도록 하며, 패브릭 등이 많이 활용된다.',
        '북유럽':'자연적인 질감과 인공적인 마감이 혼합된 느낌으로 나무,철,스테인레스,타일 소재를 주로 사용하며, 색상적인 느낌으론 밝고 깨끗한 색상을 사용하며, 흰색 벽면이 많이 사용되어 공간을 넓어 보이게 하는 특징이 있다. 목재 소재와 자연스러운 텍스처, 둥근 형태 등이 사용되어 포근하고 아늑한 분위기를 연출한다.',
        '빈티지':'짙은 갈색과 어두운 색 위주의 원목가구를 주로 사용하는 빈티지 스타일은 과거의 경험과 추억을 떠올리게 하는 요소들을 사용한다. 오래된 가구나 소품, 레트로한 패턴이나 색상 등이 활용되며, 따뜻하고 낡은 느낌을 연출한다.',
        '클래식':'큰 무늬의 체크, 스트라이프, 동물 모티브의 무늬 등 독특한 무늬가 활 용된다. 색채요소로는 2-3가지의 다양한 색상 기준으로 다채로운 색상 이 활용된다. 재료로는 플라스틱, 패브릭 등의 가벼운 소재가 활용된다. 단순하고 젊고 경쾌한 분위기를 연출한다.'
    }

    # 예측 결과 반환
    result = []
    result.append({"explanation": class_Explanation[style]})
    shopping_result = style_analysis(style)
    result.append(shopping_result)
    print(result)
    return result


# 스타일 분석에 대한 NAVER API 적용
def style_analysis(style):
    #style = request.json['style']+"스타일 가구"
    #print(style)
    encText = urllib.parse.quote(style+"스타일 가구")
    url = "https://openapi.naver.com/v1/search/shop?query=" + encText+"&sort=date"
    api_request = urllib.request.Request(url)
    api_request.add_header("X-Naver-Client-Id",client_id)
    api_request.add_header("X-Naver-Client-Secret",client_secret)
    response = urllib.request.urlopen(api_request)
    rescode = response.getcode()

    if(rescode==200):
        response_body = response.read()
        response_dict = json.loads(response_body.decode('utf-8'))
        image_urls = [item['link'] for item in response_dict['items'][:10]] if response_dict['items'] else []
        image_src = [item['image'] for item in response_dict['items'][:10]] if response_dict['items'] else []
        return {'image_urls': image_urls,'image_src':image_src}
    else:
        return {'error': 'API request error'}


# 
def find_class(file):
    # 테스트할 이미지 로드 및 전처리
    img = load_img(file, target_size=(224, 224))
    img = img_to_array(img)
    img = np.expand_dims(img, axis=0)
    img = preprocess_input(img)

    # 예측 수행
    predictions = tensor_model.predict(img)
    predicted_classes = np.argsort(-predictions[0])[:2]  # 상위 2개 클래스 선택

    # 클래스 맵
    class_map = {
        0: '모던',
        1: '캐주얼',
        2: '내추럴',
        3: '북유럽',
        4: '빈티지',
        5: '클래식'
    }

    class_Explanation={
        0:'형태적으로는 번잡한 장식 없이 직선적인 디자인으로 깨끗하고 간결한 기능미를 느낄 수 있다. 색채요소로서는 무채색 혹은 단일한 강조색이 사용되며, 강렬한 명암대비 등의 특징을 가진다. 재료로는 금속, 유리 등 딱딱하고 차가운 소재가 활용된다. 기능적이고, 합리적인 깔끔한 이미지를 준다.',
        1:'큰 무늬의 체크, 스트라이프, 동물 모티브의 무늬 등 독특한 무늬가 활 용된다. 색채요소로는 2-3가지의 다양한 색상 기준으로 다채로운 색상 이 활용된다. 재료로는 플라스틱, 패브릭 등의 가벼운 소재가 활용된다. 단순하고 젊고 경쾌한 분위기를 연출한다.',
        2:'자연을 떠올리게 하는 식물무늬 혹은 체크무늬 등이 활용된다. 색채요 소로는 자연에서 보기 쉬운 녹색계열, 아이보리계열 이 활용된다. 재료로는 목재, 흙, 돌 등이 활용된다. 목재 결 등 부재의 자연적 형태와 특 성이 잘 드러나도록 하며, 패브릭 등이 많이 활용된다.',
        3:'자연적인 질감과 인공적인 마감이 혼합된 느낌으로 나무,철,스테인레스,타일 소재를 주로 사용하며, 색상적인 느낌으론 밝고 깨끗한 색상을 사용하며, 흰색 벽면이 많이 사용되어 공간을 넓어 보이게 하는 특징이 있다. 목재 소재와 자연스러운 텍스처, 둥근 형태 등이 사용되어 포근하고 아늑한 분위기를 연출한다.',
        4:'짙은 갈색과 어두운 색 위주의 원목가구를 주로 사용하는 빈티지 스타일은 과거의 경험과 추억을 떠올리게 하는 요소들을 사용한다. 오래된 가구나 소품, 레트로한 패턴이나 색상 등이 활용되며, 따뜻하고 낡은 느낌을 연출한다.',
        5:'큰 무늬의 체크, 스트라이프, 동물 모티브의 무늬 등 독특한 무늬가 활 용된다. 색채요소로는 2-3가지의 다양한 색상 기준으로 다채로운 색상 이 활용된다. 재료로는 플라스틱, 패브릭 등의 가벼운 소재가 활용된다. 단순하고 젊고 경쾌한 분위기를 연출한다.'
    }

    # 예측 결과 반환
    result = []
    for i, class_index in enumerate(predicted_classes):
        class_name = class_map[class_index]
        class_probability = float(predictions[0][class_index])
        result.append({"class": class_name, "probability": class_probability, "explanation": class_Explanation[class_index]})
    style=result[0]['class']
    shopping_result = style_analysis(style)
    result.append(shopping_result)
    print(result)
    return result



# 이미지 업로드 및 결과 반환하는 엔드포인트 정의
@app.route("/upload", methods=["POST"])
def upload_image():
    from flask import request # request 객체를 참조하기 전에 request 변수를 선언하고 초기화
    if "file" not in request.files:
        return "No file uploaded.", 400
    memID=request.form.get("memID")
    file = request.files["file"]
    filename=file.filename
    if file.filename == "":
        return "No file selected.", 400

    if memID != "":
        img_path="D:/total/easyTerior_total/src/main/webapp/resources/images/style/"+memID+"_"+filename
        #img_path="D:/total2/easyTerior_total/src/main/webapp/style/"+memID+"_"+filename
        file.save(img_path)

        result = find_class(img_path)
        result.append({"img_path":(memID+"_"+filename)})
        print(result)

    else:
        # BytesIO 객체로 변환 파일을 저장하지 않을 때 사용 했던 코드
        image_bytes = BytesIO()
        file.save(image_bytes)
        image_bytes.seek(0)

        # 결과 반환
        result = find_class(image_bytes)


    #print(result)
    #print(img_path)
    return jsonify(result)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
