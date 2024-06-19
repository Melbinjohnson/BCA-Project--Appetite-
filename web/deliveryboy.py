from flask import *
from database import *
import uuid

deliveryboy=Blueprint('deliveryboy',__name__)

@deliveryboy.route('/dhome')
def dhome():

    return render_template('deliveryboy_home.html')

@deliveryboy.route('/deliveryreg',methods=['get','post'])
def deliveryreg():
    if 'submit' in request.form:
        data={}
        image=request.files['image'];
        path="static/uploads/"+str(uuid.uuid4())+image.filename
        image.save(path)

    
        fname=request.form['fname']
        lname=request.form['lname']
        place=request.form['place']
        phone=request.form['phone']
        email=request.form['email']
        
        uname=request.form['username']
        passw=request.form['passw']
        
        q="insert into login values(null,'%s','%s','deliveryboy')"%(uname,passw)
        id=insert(q)
        q="insert into delivery_boy values(null,'%s','%s','%s','%s','%s','%s','%s')"%(id,fname,lname,place,phone,email,path)
        insert(q)
        return redirect(url_for('deliveryboy.deliveryreg'))
        
    return render_template("deliveryboy_reg.html")

@deliveryboy.route('/deliveryviewreq')
def deliveryviewreq():
    data={}
    
    q="(SELECT CONCAT(fname,lname) AS `name`,request_id,place,phone,food,details,request.status AS rstatus FROM request,`user`,fooddetails WHERE request.foodrequest_id=user.user_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='user')UNION(SELECT CONCAT(NAME) AS `name`,request_id,place,phone,food,details,request.status AS rstatus FROM request,`organization`,fooddetails WHERE request.foodrequest_id=organization.organization_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='organization')"
    print(q)
    res=select(q)
    
    if 'action' in request.args:
        action=request.args['action']
        rid=request.args['rid']
    else:
        action=None
    if action=='pickup':
        up="update  request set set status='pickedup' where request_id='%s'"%(rid)
        update(up)
        return redirect(url_for('deliveryboy.deliveryviewreq'))
    
    if action=='delivered':
        up="update  request set set status='delivered' where request_id='%s'"%(rid)
        update(up)
        return redirect(url_for('deliveryboy.deliveryviewreq'))
    
    return render_template("deliveryviewreq.html")
    
    