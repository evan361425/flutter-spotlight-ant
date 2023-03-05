self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var B={Ct:function Ct(){},CZ:function CZ(d){this.a=d},
aiI(d,e,f){var x,w,v,u,t,s=d==null
if(s&&e==null)return null
if(s)return new B.fr(e.a,e.b,e.c.S(0,f),e.d,e.e*A.F(f,0,1))
if(e==null)return new B.fr(d.a,d.b,d.c.S(0,f),d.d,d.e*A.F(1-f,0,1))
if(f===0)return d
if(f===1)return e
s=A.v(d.a,e.a,f)
s.toString
x=f<0.5?d.b:e.b
w=A.nT(d.c,e.c,f)
w.toString
v=d.d
u=e.d
t=d.e
return new B.fr(s,x,w,v+(u-v)*f,A.F(t+(e.e-t)*f,0,1))},
D_:function D_(d,e){this.a=d
this.b=e},
fr:function fr(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
a7P:function a7P(d,e){var _=this
_.b=d
_.d=_.c=$
_.a=e},
vn:function vn(d,e){this.a=d
this.b=e},
F8:function F8(d,e,f){this.e=d
this.c=e
this.a=f},
apt(){return new B.jv(null)},
jv:function jv(d){this.a=d},
AI:function AI(d,e,f){var _=this
_.d=$
_.cs$=d
_.aC$=e
_.a=null
_.b=f
_.c=null},
Q6:function Q6(d){this.a=d},
Q7:function Q7(d){this.a=d},
Q8:function Q8(d){this.a=d},
xd:function xd(){},
at9(d,e,f){var x,w,v,u,t=d==null
if(t&&e==null)return null
if(t)return new A.f0(e.a*f,e.b*f,e.c*f,e.d*f)
if(e==null){x=1-f
return new A.f0(e.a.S(0,x),e.b.S(0,x),e.c.S(0,x),e.d.S(0,x))}t=A.K(d.a,e.a,f)
t.toString
w=A.K(d.b,e.b,f)
w.toString
v=A.K(d.c,e.c,f)
v.toString
u=A.K(d.d,e.d,f)
u.toString
return new A.f0(t,w,v,u)}},A,C,D,E
B=a.updateHolder(c[4],B)
A=c[0]
C=c[2]
D=c[10]
E=c[8]
B.Ct.prototype={
jN(d){var x
d=2*d-1
x=(d-0.1)*6.283185307179586
if(d<0)return-0.5*Math.pow(2,10*d)*Math.sin(x/0.4)
else return Math.pow(2,-10*d)*Math.sin(x/0.4)*0.5+1},
k(d){return"ElasticInOutCurve(0.4)"}}
B.CZ.prototype={
J(d){var x=A.tJ(d).a
return A.ahP(null,null,C.V,new B.fr(C.cx,D.Bc,C.av,0,1),D.AW,null,x,x)}}
B.D_.prototype={
F(){return"FlutterLogoStyle."+this.b}}
B.fr.prototype={
gVA(){if(this.e===1){var x=this.d
x=x!==-1&&x!==0&&x!==1}else x=!0
return x},
goR(){return!this.gVA()},
cA(d,e){if(d==null||d instanceof B.fr)return B.aiI(y.k.a(d),this,e)
return this.v0(d,e)},
cB(d,e){if(d==null||d instanceof B.fr)return B.aiI(this,y.k.a(d),e)
return this.v1(d,e)},
tk(d,e,f){return!0},
ob(d){var x,w=null,v=new B.a7P(this,w),u=v.c=A.H7(w,w,w,w,A.wM(w,A.kA(w,w,this.a,w,w,w,w,w,"Roboto",w,w,141.7004048582996,w,w,C.n0,w,w,!0,w,w,w,w,w,w,C.m,w),"Flutter"),C.aO,C.t,w,1,C.al)
u.JL()
x=C.b.gbI(u.pt(D.Jq))
v.d=new A.z(x.a,x.b,x.c,x.d)
return v},
pu(d,e){var x=$.a_().bt()
x.lH(d)
return x},
j(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof B.fr&&e.a.j(0,x.a)&&e.d===x.d&&e.e===x.e},
gA(d){return A.R(this.a,this.d,this.e,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
B.a7P.prototype={
jK(b1,b2,b3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4,a5,a6,a7,a8=this,a9=a8.b,b0=a9.c
b2=b2.R(0,new A.m(b0.a,b0.b))
x=b3.e
x.toString
w=b0.Ib(x)
if(w.gY(w))return
b0=a9.d
x=b0>0
if(x)v=D.Is
else v=b0<0?D.Io:D.Im
u=b2.a
t=b2.b
s=w.a
r=w.b
q=u+s
p=t+r
o=C.G.Jl(A.am0(C.xq,v,w).b,new A.z(u,t,q,p))
n=Math.min(Math.abs(s),Math.abs(r))
s=u+(s-n)/2
r=t+(r-n)/2
m=new A.z(s,r,s+n,r+n)
if(x){s=o.a
r=o.b
l=o.d-r
k=new A.z(s,r,s+l,r+l)}else if(b0<0){s=o.b
j=(o.d-s)*191/306
r=o.a
r+=(o.c-r-j)/2
k=new A.z(r,s,r+j,s+j)}else k=m
s=Math.abs(b0)
r=A.ajI(m,k,s)
r.toString
a9=a9.e
l=a9<1
if(l){i=$.a_().aw()
i.sa0f(new A.TT(A.J(C.c.aZ(255*a9),255,255,255),C.ff,null,C.z1))
b1.l4(new A.z(u,t,q,p),i)}if(b0!==0)if(x){h=0.6666666666666666*(r.d-r.b)*0.897029702970297
g=h/100
a9=o.a
x=o.c-a9
u=a8.d
u===$&&A.a()
t=A.K(x/2-(u.c-u.a)*g,0.31268292682926824*x-0.09142857142857143*h,b0)
t.toString
s=o.b
b1.cq(0)
if(b0<1){f=r.gav()
e=$.a_().bt()
b0=f.a
q=f.b
e.cO(0,b0,q)
b0+=x
e.bq(0,b0,q-x)
e.bq(0,b0,q+x)
e.dV(0)
b1.fm(0,e)}b1.aD(0,a9+t,s+(o.d-s-(u.d-u.b)*g)/2)
b1.d4(0,g,g)
a9=a8.c
a9===$&&A.a()
a9.ao(b1,C.f)
b1.cb(0)}else if(b0<0){a9=k.d
g=0.35*(a9-k.b)*0.897029702970297/100
b0=b0>-1
if(b0){x=a8.d
x===$&&A.a()
b1.l4(x,$.a_().aw())}else b1.cq(0)
x=k.gav()
u=a8.d
u===$&&A.a()
b1.aD(0,x.a-(u.c-u.a)*g/2,a9)
b1.d4(0,g,g)
a9=a8.c
a9===$&&A.a()
a9.ao(b1,C.f)
if(b0){a9=a8.d
a9=a9.cd((a9.c-a9.a)*0.5)
b0=$.a_().aw()
b0.syb(C.ff)
x=a8.d
x=x.c-x.a
b0.suQ(A.Vo(new A.m(x*-0.5,0),new A.m(x*1.5,0),A.b([C.i,C.i,C.dK,C.dK],y.c),A.b([0,Math.max(0,s-0.1),Math.min(s+0.1,1),1],y.h),C.cl))
b1.c5(a9,b0)}b1.cb(0)}b1.cq(0)
a9=r.a
b0=r.b
b1.aD(0,a9,b0)
b1.d4(0,(r.c-a9)/202,(r.d-b0)/202)
b1.aD(0,18,0)
b0=$.a_()
d=b0.aw()
d.sa6(0,D.zH)
a0=b0.aw()
a0.sa6(0,D.zv)
a1=b0.aw()
a1.sa6(0,D.zl)
a2=A.Vo(D.Gm,D.Gp,A.b([D.zc,D.zb],y.c),null,C.cl)
a3=b0.aw()
a3.suQ(a2)
a4=b0.bt()
a4.cO(0,37.7,128.9)
a4.bq(0,9.8,101)
a4.bq(0,100.4,10.4)
a4.bq(0,156.2,10.4)
b1.ce(a4,d)
a5=b0.bt()
a5.cO(0,156.2,94)
a5.bq(0,100.4,94)
a5.bq(0,78.5,115.9)
a5.bq(0,106.4,143.8)
b1.ce(a5,d)
a6=b0.bt()
a6.cO(0,79.5,170.7)
a6.bq(0,100.4,191.6)
a6.bq(0,156.2,191.6)
a6.bq(0,107.4,142.8)
b1.ce(a6,a1)
b1.cq(0)
b1.T(0,new Float64Array(A.Ac(D.CY)))
b1.c5(D.GT,a0)
b1.cb(0)
a7=b0.bt()
a7.cO(0,79.5,170.7)
a7.bq(0,120.9,156.4)
a7.bq(0,107.4,142.8)
b1.ce(a7,a3)
b1.cb(0)
if(l)b1.cb(0)}}
B.vn.prototype={
cN(d){var x=B.at9(this.a,this.b,d)
x.toString
return x}}
B.F8.prototype={
J(d){var x=y.n.a(this.c)
x=x.gl(x)
return new A.ki(x.a,x.b,x.c,x.d,null,null,this.e,null)}}
B.jv.prototype={
ah(){return new B.AI(null,null,C.j)}}
B.AI.prototype={
gCB(){var x,w=this,v=w.d
if(v===$){x=A.bl(null,C.dS,null,null,w)
x.a5E(0,!0)
w.d!==$&&A.aN()
w.d=x
v=x}return v},
m(){this.gCB().m()
this.OA()},
J(d){var x=null,w=A.iy(!1,x,!0,D.NA,x,!0,x,x,x,x,x,x,x,x,x,new B.Q6(d),x,x,x,x,x,x,x)
return new A.k8(A.AK(A.b([A.fv(x,E.dX,x,new B.Q7(d),x)],y.u),x,w),x,new A.DD(new B.Q8(this),x),x,x,x)}}
B.xd.prototype={
c1(){this.cR()
this.cu()
this.d7()},
m(){var x=this,w=x.aC$
if(w!=null)w.E(0,x.gcY())
x.aC$=null
x.aL()}}
var z=a.updateTypes([])
B.Q6.prototype={
$0(){return A.ec(this.a).cW()},
$S:0}
B.Q7.prototype={
$0(){return A.ec(this.a).cW()},
$S:0}
B.Q8.prototype={
$2(d,e){var x=null,w=A.F(1/0,e.a,e.b),v=A.F(1/0,e.c,e.d),u=new A.D(w,v),t=A.afV(D.GS,u)
w-=200
v-=200
v=A.afV(new A.z(w,v,w+200,v+200),u)
return A.fK(C.aQ,A.b([A.afM(new B.F8(D.Gy,new A.aG(A.by(D.xN,this.a.gCB(),x),new B.vn(t,v),y.B.i("aG<ai.T>")),x),x,x)],y.u),C.aN)},
$S:407};(function aliases(){var x=B.xd.prototype
x.OA=x.m})();(function inheritance(){var x=a.mixinHard,w=a.inherit,v=a.inheritMany
w(B.Ct,A.es)
w(B.CZ,A.aE)
w(B.D_,A.xD)
w(B.fr,A.e4)
w(B.a7P,A.rA)
w(B.vn,A.aj)
w(B.F8,A.nj)
w(B.jv,A.Z)
w(B.xd,A.ac)
w(B.AI,B.xd)
v(A.jB,[B.Q6,B.Q7])
w(B.Q8,A.rM)
x(B.xd,A.cz)})()
A.O2(b.typeUniverse,JSON.parse('{"Ct":{"es":[]},"CZ":{"aE":[],"i":[]},"D_":{"I":[]},"fr":{"e4":[]},"vn":{"aj":["f0"],"ai":["f0"],"aj.T":"f0","ai.T":"f0"},"F8":{"Z":[],"i":[]},"jv":{"Z":[],"i":[]},"AI":{"ac":["jv"]}}'))
var y={n:A.a1("bN<f0>"),c:A.a1("y<o>"),u:A.a1("y<i>"),h:A.a1("y<O>"),B:A.a1("vn"),k:A.a1("fr?")};(function constants(){var x=a.makeConstList
D.xN=new B.Ct()
D.zb=new A.o(1712989054)
D.zc=new A.o(1713022)
D.zl=new A.o(4278278043)
D.zv=new A.o(4280923894)
D.zH=new A.o(4283745784)
D.AW=new A.aH(75e4)
D.Bc=new B.D_(0,"markOnly")
D.CY=A.b(x([0.7071,-0.7071,0,0,0.7071,0.7071,0,0,0,0,1,0,-77.697,98.057,0,1]),y.h)
D.Gm=new A.m(125.1715,152.2773)
D.Gp=new A.m(80.8297,158.5341)
D.Bd=new B.CZ(null)
D.Gy=new A.eA(C.aq,D.Bd,null)
D.GS=new A.z(0,0,100,100)
D.GT=new A.z(59.8,123.1,99.19999999999999,162.5)
D.Im=new A.D(202,202)
D.Io=new A.D(252,306)
D.Is=new A.D(820,232)
D.Jq=new A.wI(0,7,C.A,!1,0,7)
D.NA=new A.bo("Animation Example",null,null,null,null)})()}
$__dart_deferred_initializers__["gy8yUKXiIkQUCO8Sni/SV6BLpGU="] = $__dart_deferred_initializers__.current
