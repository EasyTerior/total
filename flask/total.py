import pandas as pd
from sqlalchemy import create_engine
from PIL import Image
import base64
from io import BytesIO

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