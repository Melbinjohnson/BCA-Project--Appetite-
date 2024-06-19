from flask import *
from api import api
from admin import admin
from public import public
from resturant import resturant
from organization import organization
from deliveryboy import deliveryboy

app=Flask(__name__)
app.secret_key="hello"
app.register_blueprint(public)
app.register_blueprint(api,url_prefix='/api')
app.register_blueprint(admin,url_prefix='/admin')
app.register_blueprint(resturant,url_prefix='/resturant')
app.register_blueprint(organization,url_prefix='/organization')
app.register_blueprint(deliveryboy,url_prefix='/deliveryboy')


app.run(debug=True,port=5849,host="0.0.0.0")