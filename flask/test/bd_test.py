import pandas as pd
from sqlalchemy import create_engine
from PIL import Image
import base64
from io import BytesIO
   
engine = create_engine('mysql+pymysql://seocho_0515_2:smhrd2@project-db-stu.smhrd.com:3307/seocho_0515_2', echo = False)
buffer = BytesIO()
img_path = 'D:/SeoSeo/flaskML/images/'
im = Image.open(img_path+'person.jpg') # png -> KeyError: 'P'
# im.show()
   
im.save(buffer, format='jpeg')
img_str = base64.b64encode(buffer.getvalue())
print(f'img_str : \n{img_str}') # 변환된 데이터 확인 가능
   
img_df = pd.DataFrame({'image_data':[img_str]})

img_df.to_sql('images', con=engine, if_exists='append', index=False)