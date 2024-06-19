from flask import *
from database import *
import uuid

api=Blueprint('api',__name__)



@api.route('/login',methods=['get','post'])
def login():
    data={}
    username = request.form['username']
    password = request.form['password']
    q = "select * from login where username='%s' and password='%s'" % (username,password)
    res = select(q)
    print(q)
    if res :
        login_id=res[0]['login_id']
        print("LLLLLLLLLLLLLL",login_id)
        return jsonify(status="ok",login_id=res[0]["login_id"],usertype=res[0]['user_type'])
        
    else:
        return jsonify(status="no")






@api.route('/user_register',methods=['get','post'])
def user_register():
    data={}
    fname = request.form['fn']
    lname = request.form['ln']
    phone = request.form['phone']
    email = request.form['email']
    place=request.form['place']
    uname=request.form['username']
    passw=request.form['password']


    q1="INSERT INTO `login` VALUES(null,'%s','%s','user')"%(uname,passw)
    ids=insert(q1)
    print(q1)

    qq="insert into `user` values(null,'%s','%s','%s','%s','%s','%s')"%(ids,fname,lname,place,phone,email)
    res=insert(qq)
    print(qq)

    if res:
        return jsonify(status="success")
    else:
        return jsonify(status="no")

@api.route('/userviewprofile', methods=['GET', 'POST'])
def userviewprofile():
    data = {}
    login_idss = request.form['lids']
    print("lllllllllllllllllllllllllllllll", login_idss)
    q = "SELECT * from `user`  where  login_id='%s'" % (login_idss)
    res = select(q)
    print(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")



@api.route('/user_update_profile',methods=['get','post'])
def user_update_profile():
    data={}
    login_idss = request.form['lid']
    fname = request.form['fn']
    lname = request.form['ln']
    phone = request.form['phone']
    email = request.form['email']
    place=request.form['place']

    q="UPDATE  `user` SET fname='%s',lname='%s',email='%s',phone='%s',place='%s' where login_id='%s'" % (fname,lname,email,phone,place,login_idss)
    print(q)
    res=update(q)
    if res:
        return jsonify(status="success")
    else:
        return jsonify(status="no")





@api.route('/user_view_food',methods=['get','post'])
def user_view_food():
    data={}
    lid=request.form['lid']
    q="(SELECT resturant.name AS rname,fooddetails_id,food,details,fooddetails.date AS rdate,fooddetails.status AS rstatus,quantity FROM fooddetails INNER JOIN resturant ON (fooddetails.foodprovided_id=resturant.login_id)) UNION (SELECT CONCAT(user.fname,user.lname) AS rname,fooddetails_id,food,details,fooddetails.date AS rdate,fooddetails.status AS rstatus,quantity FROM fooddetails INNER JOIN USER ON (fooddetails.foodprovided_id=user.login_id))"
    print("------------------------",q)
    res=select(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")




@api.route('/user_make_request',methods=['get','post'])
def user_make_request():
    data={}
    id=request.form['lid']
    fdid=request.form['fooddetails_id']
    quantity=request.form['quantity']
    
    q="select * from  fooddetails where fooddetails_id='%s'"%(fdid)
    res=select(q)
    if res:
        quanty=res[0]['quantity']
        if int(quantity)>int(quanty):
            return jsonify(status="ok", data=res)
        else:
    
            q="insert into request values(null,'%s',(select user_id from user where login_id='%s'),'user','%s',curdate(),'pending')"%(fdid,id,quantity)
            insert(q)
        return jsonify(status="success", data=res)

@api.route('/user_view_request',methods=['get','post'])
def user_view_request():
    data={}
    id=request.form['lid']
    q="SELECT *,request.status as rstatus,request.quantity as quantity FROM request INNER JOIN fooddetails ON (fooddetails.fooddetails_id=request.fooddetails_id) WHERE  request.type='user' AND foodrequest_id=(select user_id from user where login_id!='%s')"%(id)
    print(q)
    res=select(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")


@api.route('/user_provide_food',methods=['get','post'])
def user_provide_food():
    data={}
    id=request.form['lid']
    place=request.form['places']
    nooffoods=request.form['foods']
    reqid=request.form['request_id']
    q="insert into foodprovided values(null,'%s','%s','%s',curdate())"%(reqid,place,nooffoods)
    insert(q)
    q="SELECT * FROM foodprovided,request,`user` u ,fooddetails WHERE foodprovided.request_id=request.request_id AND request.foodrequest_id=u.user_id AND request.fooddetails_id=fooddetails.fooddetails_id and request.`type`='user' AND u.login_id='%s'"%(id)
    res=select(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")





@api.route('/user_view_complaints',methods=['get','post'])
def user_view_complaints():
    data={}
    id=request.form['lids']
    q="select * from complaint inner join user on(complaint.user_id=user.login_id) where complaint.user_id='%s'"%(id)
    res=select(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")

@api.route('/user_send_complaint',methods=['get','post'])
def user_send_complaint():
    data={}
    id=request.form['lid']
    complaint=request.form['complaint']
    q="insert into complaint values(null,'%s','%s','pending',curdate(),'0')"%(id,complaint)
    res=insert(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")




@api.route('/my_food',methods=['get','post'])
def my_food():
    data={}
    id=request.form['lid']
    food=request.form['foods']
    fdetails=request.form['dets']
    quan=request.form['qtys']
    q="insert into fooddetails values(null,'%s','user','%s','%s','%s',curdate(),'active')"%(id,fdetails,food,quan)
    res=insert(q)
    # q="select *,fooddetails.status AS fstatus from fooddetails inner join user on (user.login_id=fooddetails.foodprovided_id) where type='user' and foodprovided_id='%s')"%(id)
    # print(q)
    # res=select(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")






@api.route('/my_food_request',methods=['get','post'])
def my_food_request():
    data={}
    id=request.form['lid']
    q="SELECT *,request.status as rstatus,request.quantity as quantity FROM request INNER JOIN fooddetails ON (fooddetails.fooddetails_id=request.fooddetails_id) WHERE  request.type='user' AND foodrequest_id=(select user_id from user where login_id='%s')"%(id)
    print(q)
    res=select(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")





@api.route('/user_accpet',methods=['get','post'])
def user_accpet():
    data={}
    id=request.form['request_id']
    # quan=request.args['quan']
    q="update request set status='accept' where request_id='%s'"%(id)
    # q="update fooddetails set quantity=quantity-'%s' where fooddetails_id=(select fooddetails_id from request where request_id='%s')"%(quan,id)
    # update(q)
    # q="update fooddetails set status='Closed' where fooddetails_id=(select fooddetails_id from request where request_id='%s') and quantity='0'"%(id)
    # update(q)
    res=update(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")



@api.route('/user_reject',methods=['get','post'])
def user_reject():
    data={}
    id=request.form['request_id']
    q="update request set status='reject' where request_id='%s'"%(id)
    res=update(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")





@api.route('/user_dispatch',methods=['get','post'])
def user_dispatch():
    data={}
    id=request.form['request_id']
    q="update request set status='dispatch' where request_id='%s'"%(id)
    res=update(q)
    if res:
        return jsonify(status="ok", data=res)
    else:
        return jsonify(status="no")








# @api.route('/deliveryreg',methods=['get','post'])
# def deliveryreg():
#     data={}
#     image=request.files['image'];
#     path="static/uploads/"+str(uuid.uuid4())+image.filename
#     image.save(path)

  
#     fname=request.form['fname']
#     lname=request.form['lname']
#     place=request.form['place']
#     phone=request.form['phone']
#     email=request.form['email']
    
#     uname=request.form['username']
#     passw=request.form['password']
#     cpassw=request.form['cpass']
    
#     if passw==cpassw:
#         q="select * from login where username='%s'"%(uname)
#         res=select(q)
#         if res:
#             data['status']='duplicate'
#         else:
#             q="insert into login values(null,'%s','%s','deliveryboy')"%(uname,passw)
#             id=insert(q)
#             q="insert into delivery_boy values(null,'%s','%s','%s','%s','%s','%s','%s')"%(id,fname,lname,place,phone,email,path)
#             insert(q)
#             data['status']='success'
#     else:
#         data['status']='password'
#     return str(data)



# @api.route('/login')
# def login():
#     data={}
#     email=request.args['username']
#     pasw =request.args['password']

#     q="select * from login where username='%s' and password='%s'"%(email,pasw)
#     print(q)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)        



# @api.route('/updateprofile')
# def updateprofile():
#     data={}
#     loginid=request.args['loginid']
#     q="select * from user where login_id='%s'"%(loginid)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)        


# @api.route('/updateprofiles')
# def updateprofiles():
#     data={}
#     loginid=request.args['loginid']
#     fname=request.args['fname']
#     lname=request.args['lname']
#     place=request.args['place']
#     phone=request.args['phone']
#     email=request.args['email']
#     q="update user set fname='%s',lname='%s',place='%s',phone='%s',email='%s' where login_id='%s'"%(fname,lname,place,phone,email,loginid)
#     update(q)
    
#     q="select * from user where login_id='%s'"%(loginid)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)   
      
# @api.route('/Viewfooddetails')
# def Viewfooddetails():
#     data={}
#     q="(SELECT resturant.name AS rname,fooddetails_id,food,details,fooddetails.date AS rdate,fooddetails.status AS rstatus,quantity FROM fooddetails INNER JOIN resturant ON (fooddetails.foodprovided_id=resturant.login_id)) UNION (SELECT CONCAT(user.fname,user.lname) AS rname,fooddetails_id,food,details,fooddetails.date AS rdate,fooddetails.status AS rstatus,quantity FROM fooddetails INNER JOIN USER ON (fooddetails.foodprovided_id=user.login_id))"
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'

#     return str(data)


# @api.route('/sendrequest')
# def sendrequest():
#     data={}
#     id=request.args['id']
#     fdid=request.args['fdid']
#     quantity=request.args['quuan']
    
#     q="select * from  fooddetails where fooddetails_id='%s'"%(fdid)
#     res=select(q)
#     if res:
#         quanty=res[0]['quantity']
#         if int(quantity)>int(quanty):
#             data['status']='exceed'   
#         else:
    
#             q="insert into request values(null,'%s',(select user_id from user where login_id='%s'),'user','%s',curdate(),'pending')"%(fdid,id,quantity)
#             insert(q)

#             data['status']='success'
#     return str(data)

# @api.route('/Viewmyrequest')
# def Viewmyrequest():
#     data={}
#     id=request.args['id']
#     q="SELECT *,request.status as rstatus,request.quantity as quantity FROM request INNER JOIN fooddetails ON (fooddetails.fooddetails_id=request.fooddetails_id) WHERE  request.type='user' AND foodrequest_id=(select user_id from user where login_id='%s')"%(id)
#     print(q)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)

# @api.route('/Viewadded')
# def Viewadded():
#     data={}
#     id=request.args['id']
#     q="SELECT * FROM foodprovided,request,`user` u ,fooddetails WHERE foodprovided.request_id=request.request_id AND request.foodrequest_id=u.user_id AND request.fooddetails_id=fooddetails.fooddetails_id and request.`type`='user' AND u.login_id='%s'"%(id)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)


# @api.route('/addprovided')
# def addprovided():
#     data={}
#     id=request.args['id']
#     place=request.args['place']
#     nooffoods=request.args['nooffoods']
#     reqid=request.args['reqid']
#     q="insert into foodprovided values(null,'%s','%s','%s',curdate())"%(reqid,place,nooffoods)
#     insert(q)
#     q="SELECT * FROM foodprovided,request,`user` u ,fooddetails WHERE foodprovided.request_id=request.request_id AND request.foodrequest_id=u.user_id AND request.fooddetails_id=fooddetails.fooddetails_id and request.`type`='user' AND u.login_id='%s'"%(id)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)



# @api.route('/viewshare')
# def viewshare():
#     data={}
#     id=request.args['id']
#     q="select *,fooddetails.status AS fstatus from fooddetails inner join user on (user.login_id=fooddetails.foodprovided_id) where type='user' and foodprovided_id='%s'"%(id)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)



# @api.route('/my_food')
# def my_food():
#     data={}
#     id=request.form['lids']
#     food=request.form['foods']
#     fdetails=request.form['dets']
#     quan=request.form['qtys']
#     q="insert into fooddetails values(null,'%s','user','%s','%s','%s',curdate(),'active')"%(id,fdetails,food,quan)
#     insert(q)
#     q="select *,fooddetails.status AS fstatus from fooddetails inner join user on (user.login_id=fooddetails.foodprovided_id) where type='user' and foodprovided_id='%s')"%(id)
#     print(q)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)


# @api.route('/foodrequestsavailable')
# def foodrequestsavailable():
#     data={}
#     id=request.args['id']
#     q="(SELECT CONCAT(fname,lname) AS `name`,request_id,place,phone,food,details,request.status AS rstatus,request.quantity as quantity FROM request,`user`,fooddetails WHERE request.foodrequest_id=user.user_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='user' and foodprovided_id='%s' )UNION(SELECT CONCAT(NAME) AS `name`,request_id,place,phone,food,details,request.status AS rstatus,request.quantity as quantity  FROM request,`organization`,fooddetails WHERE request.foodrequest_id=organization.organization_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='organization' and foodprovided_id='%s' )"%(id,id)
#     print(q)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)


# @api.route('/requestacpt')
# def requetacpt():
#     data={}
#     id=request.args['id']
#     quan=request.args['quan']
#     q="update request set status='accept' where request_id='%s'"%(id)
#     q="update fooddetails set quantity=quantity-'%s' where fooddetails_id=(select fooddetails_id from request where request_id='%s')"%(quan,id)
#     update(q)
#     q="update fooddetails set status='Closed' where fooddetails_id=(select fooddetails_id from request where request_id='%s') and quantity='0'"%(id)
#     update(q)
#     update(q)
#     data['status']='success'
#     return str(data)



# @api.route('/requestrejt')
# def requestrejt():
#     data={}
#     id=request.args['id']
#     q="update request set status='reject' where request_id='%s'"%(id)
#     update(q)
#     data['status']='success'
#     return str(data)



# @api.route('/requestdispatch')
# def requestdispatch():
#     data={}
#     id=request.args['id']
#     q="update request set status='dispatch' where request_id='%s'"%(id)
#     update(q)
#     data['status']='success'
#     return str(data)



# @api.route('/viewreply')
# def viewreply():
#     data={}
#     id=request.args['id']
#     q="select * from complaint inner join user on(complaint.user_id=user.login_id) where complaint.user_id='%s'"%(id)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)

# @api.route('/sendcomplaint')
# def sendcomplaint():
#     data={}
#     id=request.args['id']
#     complaint=request.args['complaint']
#     q="insert into complaint values(null,'%s','%s','pending',curdate(),'0')"%(id,complaint)
#     insert(q)
#     data['status']='success'
#     return str(data)


# @api.route('/deliveryviewreq')
# def deliveryviewreq():
#     data={}
#     q="(SELECT CONCAT(fname,lname) AS `name`,request_id,place,phone,food,details,request.status AS rstatus FROM request,`user`,fooddetails WHERE request.foodrequest_id=user.user_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='user')UNION(SELECT CONCAT(NAME) AS `name`,request_id,place,phone,food,details,request.status AS rstatus FROM request,`organization`,fooddetails WHERE request.foodrequest_id=organization.organization_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='organization')"
#     print(q)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)

# @api.route('/deliverypickup')
# def deliverypickup():
#     data={}
#     id=request.args['id']
#     q="update request set status='Pick up' where request_id='%s'"%(id)
#     update(q)
#     data['status']='success'

# @api.route('/deliveryviewpicked')
# def deliveryviewpicked():
#     data={}
#     id=request.args['id']
#     q="(SELECT CONCAT(fname,lname) AS `name`,request_id,place,phone,food,details,request.status AS rstatus FROM request,`user`,fooddetails WHERE request.foodrequest_id=user.user_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='user' and request.status='Pick Up')UNION(SELECT CONCAT(NAME) AS `name`,request_id,place,phone,food,details,request.status AS rstatus FROM request,`organization`,fooddetails WHERE request.foodrequest_id=organization.organization_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='organization' and request.status='Pick Up' )"
#     print(q)
#     res=select(q)
#     if res:
#         data['status']='success'
#         data['data']=res
#     else:
#         data['status']='failed'
#     return str(data)

# @api.route('/deliverydelivered')
# def deliverydelivered():
#     data={}
#     id=request.args['id']
#     q="update request set status='delivered' where request_id='%s'"%(id)
#     update(q)
#     data['status']='success'
    
    
# @api.route('/confirmdelievry')
# def confirmdelievry():
#     data={}
#     reqid=request.args['reqid']
#     q="update request set status='Confirm Delivery' where request_id='%s'"%(reqid)
#     update(q)
#     data['status']='success'
#     return str(data)


# @api.route("/addratings")
# def addratings():
#     data={}
#     req_id=request.args['req_id']
#     logid=request.args['log_id']
#     rating=request.args['rating']
    
#     q="select * from request where request_id='%s'"%(req_id)
#     ress=select(q)
#     fid=ress[0]['fooddetails_id']
    
#     q="select * from rating where user_id=(select user_id from user where login_id='%s') and fooddetails_id='%s' "%(logid,fid)
#     test=select(q)
#     if test:
#         q="update rating set rate='%s' where user_id=(select user_id from user where login_id='%s') and fooddetails_id='%s'"%(rating,logid,fid)
#         update(q)
#         data['status']='success'
#     else:
#         q="insert into rating values(null,(select user_id from user where login_id='%s'),'%s','%s',curdate())"%(logid,fid,rating)
#         res=insert(q)
#         if res:
#             data['status']='success'
        
#         else:
#             data['status']='failed'
#     data['method']="addratings"
#     return str(data)


# @api.route("/viewrating")
# def viewrating():
#     data={}
#     req_id=request.args['req_id']
#     logid=request.args['log_id']
#     q="select * from request where request_id='%s'"%(req_id)
#     ress=select(q)
#     fid=ress[0]['fooddetails_id']
   
#     q="select rate from rating inner join user using(user_id) where user_id=(select user_id from user where login_id='%s') and fooddetails_id='%s'"%(logid,fid)
#     res=select(q)
#     if res:
#         data['status']='okey'
#         data['data']=res[0]['rate']
#     else:
#         data['status']='failed'
#     data['method']="viewratings"
#     return str(data)