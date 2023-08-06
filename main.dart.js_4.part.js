self.$__dart_deferred_initializers__=self.$__dart_deferred_initializers__||Object.create(null)
$__dart_deferred_initializers__.current=function(a,b,c,$){var B={Ti:function Ti(d,e){this.a=d
this.b=e},Cn:function Cn(){},CS:function CS(d){this.a=d},
ahk(d,e,f){var x,w,v,u,t,s
if(d==e)return d
if(d==null)return new B.fw(e.a,e.b,e.c.P(0,f),e.d,e.e*A.G(f,0,1))
if(e==null)return new B.fw(d.a,d.b,d.c.P(0,f),d.d,d.e*A.G(1-f,0,1))
if(f===0)return d
if(f===1)return e
x=A.t(d.a,e.a,f)
x.toString
w=f<0.5?d.b:e.b
v=A.nU(d.c,e.c,f)
v.toString
u=d.d
t=e.d
s=d.e
return new B.fw(x,w,v,u+(t-u)*f,A.G(s+(e.e-s)*f,0,1))},
U4:function U4(d,e){this.a=d
this.b=e},
fw:function fw(d,e,f,g,h){var _=this
_.a=d
_.b=e
_.c=f
_.d=g
_.e=h},
a6_:function a6_(d,e){var _=this
_.b=d
_.d=_.c=$
_.a=e},
vm:function vm(d,e){this.a=d
this.b=e},
F8:function F8(d,e,f){this.e=d
this.c=e
this.a=f},
aon(){return new B.jF(null)},
jF:function jF(d){this.a=d},
AZ:function AZ(d,e,f){var _=this
_.d=$
_.cD$=d
_.aE$=e
_.a=null
_.b=f
_.c=null},
Qt:function Qt(d){this.a=d},
Qu:function Qu(d){this.a=d},
Qv:function Qv(d){this.a=d},
x8:function x8(){},
ast(d,e,f){var x,w,v,u,t
if(d==e)return d
if(d==null)return new A.fe(e.a*f,e.b*f,e.c*f,e.d*f)
if(e==null){x=1-f
return new A.fe(e.a.P(0,x),e.b.P(0,x),e.c.P(0,x),e.d.P(0,x))}w=A.M(d.a,e.a,f)
w.toString
v=A.M(d.b,e.b,f)
v.toString
u=A.M(d.c,e.c,f)
u.toString
t=A.M(d.d,e.d,f)
t.toString
return new A.fe(w,v,u,t)}},A,C,D,E
B=a.updateHolder(c[4],B)
A=c[0]
C=c[2]
D=c[10]
E=c[8]
B.Ti.prototype={}
B.Cn.prototype={
iX(d){var x
d=2*d-1
x=(d-0.1)*6.283185307179586
if(d<0)return-0.5*Math.pow(2,10*d)*Math.sin(x/0.4)
else return Math.pow(2,-10*d)*Math.sin(x/0.4)*0.5+1},
k(d){return"ElasticInOutCurve(0.4)"}}
B.CS.prototype={
J(d){var x=A.tP(d).a
return A.agi(null,null,C.V,new B.fw(C.cJ,D.Bc,C.ar,0,1),D.AU,null,x,x)}}
B.U4.prototype={
D(){return"FlutterLogoStyle."+this.b}}
B.fw.prototype={
gXa(){if(this.e===1){var x=this.d
x=x!==-1&&x!==0&&x!==1}else x=!0
return x},
gpA(){return!this.gXa()},
cJ(d,e){if(d==null||d instanceof B.fw)return B.ahk(y.k.a(d),this,e)
return this.vQ(d,e)},
cK(d,e){if(d==null||d instanceof B.fw)return B.ahk(this,y.k.a(d),e)
return this.vR(d,e)},
u7(d,e,f){return!0},
oQ(d){var x,w=null,v=new B.a6_(this,w),u=v.c=A.H2(w,w,w,w,A.wL(w,A.kK(w,w,this.a,w,w,w,w,w,"Roboto",w,w,141.7004048582996,w,w,C.kH,w,w,!0,w,w,w,w,w,w,C.m,w),"Flutter"),C.aQ,C.t,w,1,C.aj)
u.Lg()
x=C.b.gc3(u.qb(D.K3))
v.d=new A.z(x.a,x.b,x.c,x.d)
return v},
qc(d,e){var x=$.a_().bB()
x.m_(d)
return x},
j(d,e){var x=this
if(e==null)return!1
if(x===e)return!0
return e instanceof B.fw&&e.a.j(0,x.a)&&e.d===x.d&&e.e===x.e},
gA(d){return A.P(this.a,this.d,this.e,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a,C.a)}}
B.a6_.prototype={
jT(b1,b2,b3){var x,w,v,u,t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,a0,a1,a2,a3,a4,a5,a6,a7,a8=this,a9=a8.b,b0=a9.c
b2=b2.M(0,new A.l(b0.a,b0.b))
x=b3.e
x.toString
w=b0.Jt(x)
if(w.gY(w))return
b0=a9.d
x=b0>0
if(x)v=D.J3
else v=b0<0?D.J_:D.IY
u=b2.a
t=b2.b
s=w.a
r=w.b
q=u+s
p=t+r
o=C.E.KM(A.akX(C.xk,v,w).b,new A.z(u,t,q,p))
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
r=A.ais(m,k,s)
r.toString
a9=a9.e
l=a9<1
if(l){i=$.a_().au()
i.sa25(new B.Ti(A.A(C.c.aU(255*a9),255,255,255),C.fx))
b1.li(new A.z(u,t,q,p),i)}if(b0!==0)if(x){h=0.6666666666666666*(r.d-r.b)*0.897029702970297
g=h/100
a9=o.a
x=o.c-a9
u=a8.d
u===$&&A.a()
t=A.M(x/2-(u.c-u.a)*g,0.31268292682926824*x-0.09142857142857143*h,b0)
t.toString
s=o.b
b1.cA(0)
if(b0<1){f=r.gan()
e=$.a_().bB()
b0=f.a
q=f.b
e.cV(0,b0,q)
b0+=x
e.bz(0,b0,q-x)
e.bz(0,b0,q+x)
e.cR(0)
b1.fI(0,e)}b1.aB(0,a9+t,s+(o.d-s-(u.d-u.b)*g)/2)
b1.d4(0,g,g)
a9=a8.c
a9===$&&A.a()
a9.ap(b1,C.f)
b1.cf(0)}else if(b0<0){a9=k.d
g=0.35*(a9-k.b)*0.897029702970297/100
b0=b0>-1
if(b0){x=a8.d
x===$&&A.a()
b1.li(x,$.a_().au())}else b1.cA(0)
x=k.gan()
u=a8.d
u===$&&A.a()
b1.aB(0,x.a-(u.c-u.a)*g/2,a9)
b1.d4(0,g,g)
a9=a8.c
a9===$&&A.a()
a9.ap(b1,C.f)
if(b0){a9=a8.d
a9=a9.cd((a9.c-a9.a)*0.5)
b0=$.a_().au()
b0.sz3(C.fx)
x=a8.d
x=x.c-x.a
b0.sqt(A.UR(new A.l(x*-0.5,0),new A.l(x*1.5,0),A.b([C.i,C.i,C.dV,C.dV],y.c),A.b([0,Math.max(0,s-0.1),Math.min(s+0.1,1),1],y.h),C.bk))
b1.c8(a9,b0)}b1.cf(0)}b1.cA(0)
a9=r.a
b0=r.b
b1.aB(0,a9,b0)
b1.d4(0,(r.c-a9)/202,(r.d-b0)/202)
b1.aB(0,18,0)
b0=$.a_()
d=b0.au()
d.sa8(0,D.zE)
a0=b0.au()
a0.sa8(0,D.zs)
a1=b0.au()
a1.sa8(0,D.zi)
a2=A.UR(D.Gi,D.Gn,A.b([D.z9,D.z8],y.c),null,C.bk)
a3=b0.au()
a3.sqt(a2)
a4=b0.bB()
a4.cV(0,37.7,128.9)
a4.bz(0,9.8,101)
a4.bz(0,100.4,10.4)
a4.bz(0,156.2,10.4)
b1.cl(a4,d)
a5=b0.bB()
a5.cV(0,156.2,94)
a5.bz(0,100.4,94)
a5.bz(0,78.5,115.9)
a5.bz(0,106.4,143.8)
b1.cl(a5,d)
a6=b0.bB()
a6.cV(0,79.5,170.7)
a6.bz(0,100.4,191.6)
a6.bz(0,156.2,191.6)
a6.bz(0,107.4,142.8)
b1.cl(a6,a1)
b1.cA(0)
b1.S(0,new Float64Array(A.Am(D.D6)))
b1.c8(D.Hr,a0)
b1.cf(0)
a7=b0.bB()
a7.cV(0,79.5,170.7)
a7.bz(0,120.9,156.4)
a7.bz(0,107.4,142.8)
b1.cl(a7,a3)
b1.cf(0)
if(l)b1.cf(0)}}
B.vm.prototype={
cU(d){var x=B.ast(this.a,this.b,d)
x.toString
return x}}
B.F8.prototype={
J(d){var x=y.n.a(this.c)
x=x.gl(x)
return new A.ko(x.a,x.b,x.c,x.d,null,null,this.e,null)}}
B.jF.prototype={
ah(){return new B.AZ(null,null,C.j)}}
B.AZ.prototype={
gDD(){var x,w=this,v=w.d
if(v===$){x=A.bn(null,C.e1,null,null,w)
x.a7t(0,!0)
w.d!==$&&A.an()
w.d=x
v=x}return v},
m(){this.gDD().m()
this.Q8()},
J(d){var x=null,w=A.iK(!1,x,!0,D.Od,x,!0,x,x,x,x,x,x,x,x,x,new B.Qt(d),x,x,x,x,x,x,x)
return new A.kf(A.rn(A.b([A.ht(x,E.e5,new B.Qu(d),x,x)],y.u),x,w),x,new A.Dy(new B.Qv(this),x),x,x,x)}}
B.x8.prototype={
c5(){this.d0()
this.cG()
this.dg()},
m(){var x=this,w=x.aE$
if(w!=null)w.F(0,x.gd7())
x.aE$=null
x.aN()}}
var z=a.updateTypes([])
B.Qt.prototype={
$0(){return A.dF(this.a).cW()},
$S:0}
B.Qu.prototype={
$0(){return A.dF(this.a).cW()},
$S:0}
B.Qv.prototype={
$2(d,e){var x=null,w=A.G(1/0,e.a,e.b),v=A.G(1/0,e.c,e.d),u=new A.D(w,v),t=A.aeg(D.Hq,u)
w-=200
v-=200
v=A.aeg(new A.z(w,v,w+200,v+200),u)
return A.hW(C.b8,A.b([A.ae6(new B.F8(D.Gz,new A.aJ(A.bA(D.xG,this.a.gDD(),x),new B.vm(t,v),y.B.i("aJ<ai.T>")),x),x,x)],y.u),C.b1)},
$S:425};(function aliases(){var x=B.x8.prototype
x.Q8=x.m})();(function inheritance(){var x=a.mixinHard,w=a.inherit,v=a.inheritMany
w(B.Ti,A.H)
w(B.Cn,A.eb)
w(B.CS,A.ax)
w(B.U4,A.xH)
w(B.fw,A.ec)
w(B.a6_,A.rz)
w(B.vm,A.aj)
w(B.F8,A.nl)
w(B.jF,A.Z)
w(B.x8,A.ac)
w(B.AZ,B.x8)
v(A.jM,[B.Qt,B.Qu])
w(B.Qv,A.rJ)
x(B.x8,A.cH)})()
A.Oi(b.typeUniverse,JSON.parse('{"Cn":{"eb":[]},"CS":{"ax":[],"h":[]},"fw":{"ec":[]},"vm":{"aj":["fe"],"ai":["fe"],"aj.T":"fe","ai.T":"fe"},"F8":{"Z":[],"h":[]},"jF":{"Z":[],"h":[]},"AZ":{"ac":["jF"]}}'))
var y={n:A.W("bQ<fe>"),c:A.W("x<o>"),u:A.W("x<h>"),h:A.W("x<L>"),B:A.W("vm"),k:A.W("fw?")};(function constants(){var x=a.makeConstList
D.xG=new B.Cn()
D.z8=new A.o(1712989054)
D.z9=new A.o(1713022)
D.zi=new A.o(4278278043)
D.zs=new A.o(4280923894)
D.zE=new A.o(4283745784)
D.AU=new A.aP(75e4)
D.Bc=new B.U4(0,"markOnly")
D.D6=A.b(x([0.7071,-0.7071,0,0,0.7071,0.7071,0,0,0,0,1,0,-77.697,98.057,0,1]),y.h)
D.Gi=new A.l(125.1715,152.2773)
D.Gn=new A.l(80.8297,158.5341)
D.Bd=new B.CS(null)
D.Gz=new A.eI(C.as,D.Bd,null)
D.Hq=new A.z(0,0,100,100)
D.Hr=new A.z(59.8,123.1,99.19999999999999,162.5)
D.IY=new A.D(202,202)
D.J_=new A.D(252,306)
D.J3=new A.D(820,232)
D.K3=new A.wI(0,7,C.P,!1,0,7)
D.Od=new A.bm("Animation Example",null,null,null,null)})()}
$__dart_deferred_initializers__["UAy4c7XuPi9gcXidq/EGSYnZt1I="] = $__dart_deferred_initializers__.current
