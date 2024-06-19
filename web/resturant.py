from flask import *
from database import *

resturant=Blueprint('resturant',__name__)

@resturant.route('/rhome')
def rhome():

    return render_template('resturant_home.html')

@resturant.route('/resturantaddfooddetails',methods=['get','post'])
def resturantaddfooddetails():
    data={}
    if 'add' in request.form:
        fname=request.form['fname']
        det=request.form['det']
        qty=request.form['qty']
        q="insert into fooddetails values(null,'%s','resturant','%s','%s','%s',curdate(),'active')"%(session['logid'],fname,det,qty)
        insert(q)
        flash("food added successfully...")
        return redirect(url_for('resturant.resturantaddfooddetails'))


    q="select * from fooddetails inner join resturant on (resturant.login_id=fooddetails.foodprovided_id) where type='resturant' and foodprovided_id='%s'"%(session['logid'])
    data['fdetails']=select(q)
    
    if 'fid' in request.args:
        fid=request.args['fid']
        q="delete from fooddetails where fooddetails_id='%s'"%(fid)
        delete(q) 
        flash("deleted succesfully")
        return redirect(url_for('resturant.resturantaddfooddetails'))

    if 'oid' in request.args:
        fid=request.args['oid']
        q="update fooddetails set status='inactive' where fooddetails_id='%s'"%(fid)
        delete(q) 
        flash("status Updated succesfully")
        return redirect(url_for('resturant.resturantaddfooddetails'))

    return render_template('resturant_add_fooddetails.html',data=data)

@resturant.route('/resturantviewfoodrequests')
def resturantviewfoodrequests():
    data={}
    q="(SELECT CONCAT(fname,lname) AS `name`,request_id,place,phone,food,details,request.status AS rstatus,request.quantity as quantity FROM request,`user`,fooddetails WHERE request.foodrequest_id=user.user_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='user' and foodprovided_id='%s' )UNION(SELECT CONCAT(NAME) AS `name`,request_id,place,phone,food,details,request.status AS rstatus,request.quantity as quantity FROM request,`organization`,fooddetails WHERE request.foodrequest_id=organization.organization_id AND request.fooddetails_id=fooddetails.fooddetails_id AND request.type='organization' and foodprovided_id='%s' )"%(session['logid'],session['logid'])
    data['viewrequest']=select(q)

    if 'action' in request.args:
        req_id=request.args['req_id']
        action=request.args['action']
        quan=request.args['quan']

    else:
        action=None
    
    if action=="accept":
        q="update request set status='accept' where request_id='%s'"%(req_id)
        update(q)

        
        q="update fooddetails set quantity=quantity-'%s' where fooddetails_id=(select fooddetails_id from request where request_id='%s')"%(quan,req_id)
        update(q)
        q="update fooddetails set status='Closed' where fooddetails_id=(select fooddetails_id from request where request_id='%s') and quantity='0'"%(req_id)
        update(q)
        flash("request accepted.....")
        return redirect(url_for('resturant.resturantviewfoodrequests'))

    if action=="reject":
        q="update request set status='reject' where request_id='%s'"%(req_id)
        update(q)
        flash("request Rejected.....")
        return redirect(url_for('resturant.resturantviewfoodrequests'))
    

    if action=="dispatch":
        q="update request set status='dispatch' where request_id='%s'"%(req_id)
        update(q)
        flash("Food Dispatched.....")
        return redirect(url_for('resturant.resturantviewfoodrequests'))

    return render_template('resturant_view_request.html',data=data)


@resturant.route('/resturantsendcomplaints',methods=['get','post'])
def resturantsendcomplaints():
    data={}
    if 'complaint' in request.form:
        comp=request.form['comp']
        q="insert into complaint values(null,'%s','%s',now(),'pending','')"%(session['logid'],comp)
        insert(q)
        flash("complaint registered......")
        return redirect(url_for('resturant.resturantsendcomplaints'))
    
    q="select * from complaint,resturant where complaint.user_id=resturant.login_id and login_id='%s'"%(session['logid'])
    data['res']=select(q)
    return render_template('resturant_send_complaint.html',data=data)