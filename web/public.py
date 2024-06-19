from flask import *
from database import *
import uuid


public=Blueprint('public',__name__)

@public.route('/')
def home():

    return render_template('home.html')



@public.route('/login',methods=['post','get'])
def login():

    if 'login' in request.form:
        email=request.form['uname']
        pasw =request.form['passw']

        q="select * from login where username='%s' and password='%s'"%(email,pasw)
        print(q)
        res=select(q)
        
        if res:
            session['logid']=res[0]["login_id"]
            utype=res[0]["user_type"]
            if utype == "admin":
                flash("Login Succeessfully")
                return redirect(url_for("admin.adhome"))
            elif utype == "resturant":
                q="select * from resturant where login_id='%s'"%(session['logid'])
                res=select(q)
                session['res_id']=res[0]['resturant_id']
                flash("Login Succeessfully")
                return redirect(url_for('resturant.rhome'))
            elif utype == "organization":
                q="select * from organization where login_id='%s'"%(session['logid'])
                res=select(q)
                session['org_id']=res[0]['organization_id']
                flash("Login Succeessfully")
                return redirect(url_for("organization.ohome"))
            elif utype == "deliveryboy":
                q="select * from delivery_boy where login_id='%s'"%(session['logid'])
                res=select(q)
                session['d_id']=res[0]['dboy_id']
                flash("Login Succeessfully")
                return redirect(url_for("deliveryboy.dhome"))
    return render_template("login.html")


@public.route('/resturantreg',methods=['get','post'])
def resturantreg():
    if 'rreg' in request.form:
        rname=request.form['rname']
        place=request.form['place']
        phone=request.form['phone']
        image=request.files['image']
        path='static/uploads/'+str(uuid.uuid4())+image.filename
        image.save(path)
        uname=request.form['uname']
        email=request.form['email']
        passw=request.form['passw']

        q=" (SELECT username,email FROM login INNER JOIN USER USING (login_id) WHERE username='%s' OR email='%s') UNION (SELECT username,email FROM login INNER JOIN organization USING (login_id) WHERE username='%s' OR email='%s') UNION (SELECT username,email FROM login INNER JOIN resturant USING (login_id) WHERE username='%s' OR email='%s')"%(uname,email,uname,email,uname,email)
        res=select(q)
        if res:
            flash("email or username alredy exists......")
   
            return redirect(url_for('public.resturantreg'))
        else:
            q="insert into login values(null,'%s','%s','resturant')"%(uname,passw)
            id=insert(q)
            q="insert into resturant values(null,'%s','%s','%s','%s','%s','%s')"%(id,rname,place,phone,email,path)
            insert(q)
            flash("Registration successfull......")
            return redirect(url_for('public.login'))
    return render_template('resturant_register.html')




@public.route('/organizationreg',methods=['get','post'])
def organizationreg():
    if 'rreg' in request.form:
        rname=request.form['rname']
        place=request.form['place']
        phone=request.form['phone']
        image=request.files['image']
        path='static/uploads/'+str(uuid.uuid4())+image.filename
        image.save(path)
        uname=request.form['uname']
        email=request.form['email']
        passw=request.form['passw']

        q=" (SELECT username,email,phone FROM login INNER JOIN USER USING (login_id) WHERE username='%s' OR email='%s' OR phone='%s') UNION (SELECT username,email,phone FROM login INNER JOIN organization USING (login_id) WHERE username='%s' OR email='%s' OR phone='%s') UNION (SELECT username,email,phone FROM login INNER JOIN resturant USING (login_id) WHERE username='%s' OR email='%s' OR phone='%s')"%(uname,email,phone,uname,email,phone,uname,email,phone)
        res=select(q)
        if res:
            flash("email or username alredy exists......")

            return redirect(url_for('public.organizationreg'))
        else:
            q="insert into login values(null,'%s','%s','organization')"%(uname,passw)
            id=insert(q)
            q="insert into organization values(null,'%s','%s','%s','%s','%s','%s')"%(id,rname,place,phone,email,path)
            insert(q)
            flash("Registration successfull......")
            return redirect(url_for('public.login'))
    return render_template('organization_register.html')