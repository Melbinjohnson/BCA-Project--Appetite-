from flask import *
from database import *
import uuid

organization=Blueprint('organization',__name__)

@organization.route('/ohome')
def ohome():

    return render_template('organization_home.html')


@organization.route('/organizationviewprofile',methods=['get','post'])
def organizationviewprofile():
    data={}
    q="select * from organization where organization_id='%s'"%(session['org_id'])
    data['res']=select(q)

    if 'edit' in request.form:
        q="select * from organization where organization_id='%s'"%(session['org_id'])
        data['edit']=select(q)

    if 'update' in request.form:
        oname=request.form['oname']
        phone=request.form['phone']
        place=request.form['place']
        email=request.form['email']
        image=request.files['image']
        path='static/uploads/'+str(uuid.uuid4())+image.filename
        image.save(path)
        
        v="update organization set name='%s',phone='%s',place='%s',email='%s',license='%s' where organization_id='%s'"%(oname,phone,place,email,license,session['org_id'])
        update(v)
        flash("Profile Updated......")
        return redirect(url_for('organization.organizationviewprofile'))
    return render_template('organization_update_profile.html',data=data)


@organization.route('/organizationviewfooddetails',methods=['get','post'])
def organizationviewfooddetails():
    data={}
    q="(SELECT resturant.name AS rname,food,details,fooddetails.date AS rdate,fooddetails.status AS rstatus,fooddetails_id,quantity FROM fooddetails INNER JOIN resturant ON (fooddetails.foodprovided_id=resturant.login_id)) UNION (SELECT CONCAT(user.fname,user.lname) AS rname,food,details,fooddetails.date AS rdate,fooddetails.status AS rstatus, fooddetails_id,quantity FROM fooddetails INNER JOIN USER ON (fooddetails.foodprovided_id=user.login_id)) "
    data['fdetails']=select(q)
    
    if 'fid' in request.args:
        fid=request.args['fid']
        data['fid']=fid

    if 'send' in request.form:
        quantity=request.form['nfood']
        fid=request.form['fid']

        q="select * from  fooddetails where fooddetails_id='%s'"%(fid)
        res=select(q)
        if res:
            quanty=res[0]['quantity']
            if int(quantity)>int(quanty):
                flash("plase Request lesser quantity...")   
            else:
       
                q="insert into request values(null,'%s','%s','organization','%s',curdate(),'pending')"%(fid,session['org_id'],quantity)
                print(q)
                insert(q)
                flash("request sent successfully......")
        return redirect(url_for('organization.organizationviewfooddetails'))

    return render_template('organization_view_food_details.html',data=data)


@organization.route('/organizationviewrequest',methods=['get','post'])
def organizationviewrequest():
    data={}
    data={}
    q="SELECT *,request.status as rstatus,request.quantity as quantity FROM request INNER JOIN fooddetails ON (fooddetails.fooddetails_id=request.fooddetails_id) WHERE  request.type='organization' AND foodrequest_id='%s'"%(session['org_id'])
    data['viewrequest']=select(q)

    if 'rid' in request.args:
        rid=request.args['rid']
        q="update request set status='confirm delivery' where request_id='%s'"%(rid)
        update(q)
        flash("Food Delivery confirmed.....")
        return redirect(url_for('organization.organizationviewrequest'))


    return render_template('organization_view_request_status.html',data=data)