from flask import *
from database import *

admin=Blueprint('admin',__name__)

@admin.route('/adhome')
def adhome():

    return render_template('admin_home.html')


@admin.route('/adminviewresturants')
def adminviewresturants():
    data={}
    q="select * from resturant"
    data['resturant']=select(q)

  


    if 'rid' in request.args:
        rid=request.args['rid']
        q="delete from resturant where resturant_id='%s'"%(rid)
        delete(q)
        q="delete from login where login_id=(select login_id from resturant where resturant_id='%s')"%(rid)
        delete(q) 
        print(q)
        flash("deleted succesfully")
        return redirect(url_for('admin.adminviewresturants'))



    return render_template('admin_view_resturants.html',data=data)

@admin.route('/adminvieworganizations')
def adminvieworganizations():
    data={}
    q="SELECT * FROM organization"
    data['organization']=select(q)

    if 'action' in request.args:
        action=request.args['action']
        oid=request.args['oid']
    else:
        action=None

    if action == 'delete':
        q="delete from organization where organization_id='%s'"%(oid)
        delete(q) 
        q="delete from login where login_id=(select login_id from organization where organization_id='%s')"%(oid)
        delete(q)
        print(q)
        flash("deleted succesfully")
        return redirect(url_for('admin.adminvieworganizations'))
    return render_template('admin_view_organization.html',data=data)
    
@admin.route('/adminviewuser')
def adminviewuser():
    data={}
    q="select * from user"
    data['uesr']=select(q)
    return render_template('admin_view_user.html',data=data)



@admin.route("/adminviewcomplaints",methods=['get','post'])
def adminviewcomplaints():

    
    data={}
    q="(SELECT CONCAT(fname,lname) AS name,complaint,complaint_id,reply,DATE ,rdate,phone,place FROM complaint,USER WHERE complaint.user_id=user.login_id ) UNION (SELECT resturant.name AS name,complaint,complaint_id,reply,DATE,rdate,phone,place  FROM complaint,resturant WHERE complaint.user_id=resturant.login_id )"
    print(q)
    data['res']=select(q)

    if 'action' in request.args:
        action=request.args['action']
        cid=request.args['cid']
        data['cid']=cid
    else:
        action=None

    if action == "reply":
        data['replysec']=True

        if 'submit' in request.form:
            reply=request.form['reply']
            ok=request.form['ok']

            q="update complaint set reply='%s',rdate=now() where complaint_id='%s'"%(reply,ok)
            print(q)
            update(q)
            return redirect(url_for("admin.adminviewcomplaints"))
    return render_template("admin_view_complaints.html",data=data)




@admin.route('/viewratings')
def viewratings():
    data={}
    q="select * from rating inner join user using(user_id) inner join fooddetails using(fooddetails_id)"
    data['res']=select(q)
    
    return render_template("admin_view_ratings.html",data=data)
     
    