"""Regenerate the original artwork and synth audio. Requires ffmpeg."""
import json, math, random, struct, subprocess, wave
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1] / 'assets'

def prop(x): return {'a':0,'k':x}
def color(hexstr): return [int(hexstr[i:i+2],16)/255 for i in (0,2,4)]+[1]
def shape(x,y,w,h,hexstr, kind='el'):
    return {'ty':'gr','it':[{'ty':kind,'p':prop([x,y]),'s':prop([w,h]),'r':prop(5),'d':1}, {'ty':'fl','c':prop(color(hexstr)),'o':prop(100),'r':1},{'ty':'tr','p':prop([0,0]),'a':prop([0,0]),'s':prop([100,100]),'r':prop(0),'o':prop(100)}]}
def path(points,hexstr):
    p={'v':points,'i':[[0,0]]*len(points),'o':[[0,0]]*len(points),'c':True}
    return {'ty':'gr','it':[{'ty':'sh','ks':prop(p)}, {'ty':'fl','c':prop(color(hexstr)),'o':prop(100),'r':1},{'ty':'tr','p':prop([0,0]),'a':prop([0,0]),'s':prop([100,100]),'r':prop(0),'o':prop(100)}]}
def keys(seq):
    return {'a':1,'k':[{'t':t,'s':v,'i':{'x':[.42],'y':[1]},'o':{'x':[.58],'y':[0]}} for t,v in seq]}
def layer(shapes,i=1,p=None,o=None,r=None):
    return {'ddd':0,'ind':i,'ty':4,'sr':1,'ks':{'o':o or prop(100),'r':r or prop(0),'p':p or prop([80,80,0]),'a':prop([80,80,0]),'s':prop([100,100,100])},'ao':0,'shapes':shapes,'ip':0,'op':60,'st':0,'bm':0}
def save(name,layers):
    (ROOT/'animations'/f'{name}.json').write_text(json.dumps({'v':'5.7.4','fr':30,'ip':0,'op':60,'w':160,'h':160,'ddd':0,'layers':layers},separators=(',',':')))
for name in ('happy','encouraging','thinking','curious','celebrate'):
    dy={'happy':4,'encouraging':3,'thinking':2,'curious':5,'celebrate':14}[name]
    eye={'happy':0,'encouraging':0,'thinking':5,'curious':-4,'celebrate':0}[name]
    s=[shape(80,143,89,10,'DFBAC0'),shape(64,135,22,10,'EF9A52'),shape(96,135,22,10,'EF9A52'),path([[34,62],[37,31],[65,48]],'B877BD'),path([[126,62],[123,31],[95,48]],'B877BD'),shape(80,88,105,94,'B877BD'),shape(80,108,63,47,'F7CCCE'),shape(36,100,25,46,'A66AAE'),shape(124,100,25,46,'A66AAE')]
    for x in (60,100): s += [shape(x,74,36,34,'FFF5DD'),shape(x+eye,74,15,17,'3D2C1E'),shape(x+eye-2,70,4,4,'FFFFFF')]
    s += [shape(48,91,13,7,'FFABBA'),shape(112,91,13,7,'FFABBA'),path([[72,85],[88,85],[80,97]],'EF913F'),shape(80,112,16,16,'FFD166'),path([[79,106],[81,106],[81,113],[84,113],[84,115],[79,115]],'915014')]
    save('owl_'+name,[layer(list(reversed(s)),p=keys([(0,[80,80,0]),(27,[80,80-dy,0]),(60,[80,80,0])]))])
rng=random.Random(12); layers=[]
for i in range(31):
    a=rng.uniform(0,math.tau); d=rng.uniform(29,93); dx=math.cos(a)*d;dy=math.sin(a)*d
    c=['FFD166','EF476F','06D6A0','118AB2','FF8C42'][i%5]
    star=[[80+math.sin(j*math.pi/5)*(8 if j%2==0 else 3.5),80-math.cos(j*math.pi/5)*(8 if j%2==0 else 3.5)] for j in range(10)]
    heart=[[80,86],[72,80],[72,76],[76,74],[80,77],[84,74],[88,76],[88,80]]
    layers.append(layer([path(star if i%3==0 else heart,c) if i%3!=2 else shape(80,80,7,4,c,'rc')],i+1,p=keys([(0,[80,80,0]),(17,[80+dx,80+dy,0]),(55,[80+dx*1.3,110+dy,0])]),o=keys([(0,[0]),(4,[100]),(24,[100]),(55,[0])]),r=keys([(0,[0]),(55,[i*27])])) )
save('confetti',layers)
rate=24000
notes={'ding':[(0,.34,880),(.09,.29,1320)],'boop':[(0,.25,262)],'tada':[(0,.24,523),(.14,.24,659),(.28,.24,784),(.42,.5,1047)],'music':[(i*.45,.74,f) for i,f in enumerate([262,330,392,440,392,330,294,349,392,349,294,262,220,262,330,196])]}
for name,seq in notes.items():
    length=max(t+d for t,d,f in seq)+.1
    pcm=[0.0]*int(rate*length)
    for t,d,f in seq:
        for j in range(int(d*rate)):
            u=j/rate; env=min(1,u/.02)*max(0,1-u/d)**2
            pcm[int(t*rate)+j]+=.32*env*(math.sin(math.tau*f*u)+.22*math.sin(math.tau*f*2*u))
    wav=ROOT/'audio'/f'{name}.wav'
    with wave.open(str(wav),'wb') as out:
        out.setparams((1,2,rate,0,'NONE','not compressed'));out.writeframes(b''.join(struct.pack('<h',int(v*32767)) for v in pcm))
    subprocess.run(['ffmpeg','-loglevel','error','-y','-i',str(wav),str(wav.with_suffix('.mp3'))],check=True);wav.unlink()
