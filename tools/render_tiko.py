"""Render the original Tiko illustration and Android launcher assets."""
from pathlib import Path
import cairosvg
from PIL import Image

root=Path(__file__).resolve().parents[1]
res=root/'android/app/src/main/res'
def render(path, elements, box, width, height):
    path.parent.mkdir(parents=True,exist_ok=True)
    svg=f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="{box}">{elements}</svg>'
    cairosvg.svg2png(bytestring=svg.encode(),write_to=str(path),output_width=width,output_height=height)

defs='''<defs>
<linearGradient id="night" x2="0" y2="1" gradientUnits="objectBoundingBox"><stop stop-color="#123e50"/><stop offset="1" stop-color="#258985"/></linearGradient>
<linearGradient id="wing" x2="0" y2="1"><stop stop-color="#64d4b4"/><stop offset="1" stop-color="#24807d"/></linearGradient>
<linearGradient id="gold" x2="0" y2="1"><stop stop-color="#ffe5a3"/><stop offset="1" stop-color="#e8a24e"/></linearGradient>
</defs>'''
star='<path d="M0 -13 Q2 -3 13 0 Q2 3 0 13 Q-2 3 -13 0 Q-2 -3 0 -13Z" fill="#ffe6a0"/>'
def spark(x,y,s=1): return f'<g transform="translate({x} {y}) scale({s})">{star}</g>'
owl='''<g stroke="#183746" stroke-width="6" stroke-linejoin="round">
<ellipse cx="160" cy="279" rx="100" ry="13" fill="#0b3442" opacity=".35" stroke="none"/>
<path d="M84 247 Q61 234 61 196 Q61 159 85 129 L69 55 Q88 49 123 75 Q160 61 197 75 Q227 46 251 55 L236 129 Q260 159 259 201 Q258 249 224 263 Q155 295 84 247Z" fill="url(#wing)"/>
<path d="M77 67 L105 82 L85 102Z M243 67 L214 83 L235 103Z" fill="#f5ae87" stroke="none"/>
<path d="M104 251 Q135 236 143 266 L148 279 Q134 284 103 278 Q91 273 104 251Z M218 251 Q187 236 179 266 L174 279 Q188 284 219 278 Q231 273 218 251Z" fill="#eeb263"/>
<path d="M160 110 Q123 79 94 108 Q63 140 91 176 Q114 200 160 189 Q207 200 230 176 Q257 138 225 107 Q195 79 160 110Z" fill="#fff0cd"/>
<g stroke="none"><ellipse cx="122" cy="142" rx="23" ry="27" fill="#193444"/><ellipse cx="198" cy="142" rx="23" ry="27" fill="#193444"/><circle cx="129" cy="133" r="8" fill="#fff"/><circle cx="205" cy="133" r="8" fill="#fff"/><circle cx="114" cy="151" r="4" fill="#aee9d5"/><circle cx="190" cy="151" r="4" fill="#aee9d5"/><ellipse cx="93" cy="167" rx="11" ry="6" fill="#f3aa96"/><ellipse cx="227" cy="167" rx="11" ry="6" fill="#f3aa96"/></g>
<path d="M149 165 Q160 157 171 165 L160 181Z" fill="#efac59" stroke-width="3"/>
<path d="M96 192 Q160 174 226 192 L232 251 Q161 279 88 253Z" fill="#b66546"/>
<circle cx="160" cy="223" r="52" fill="url(#gold)"/>
<circle cx="160" cy="223" r="40" fill="#fff5db" stroke="#89522d" stroke-width="3"/>
<path d="M160 189 v5 M160 252 v5 M126 223 h5 M189 223 h5" stroke="#a76a36" stroke-width="3" stroke-linecap="round"/>
<path d="M141 208 L160 223" stroke="#17636a" stroke-width="7" stroke-linecap="round"/>
<path d="M160 223 L182 202" stroke="#aa4d29" stroke-width="4" stroke-linecap="round"/>
<circle cx="160" cy="223" r="4" fill="#193444" stroke="none"/>
<path d="M79 186 Q54 197 71 225 Q84 245 113 244 Q116 237 107 230 Q87 221 91 199Z M241 186 Q266 197 249 225 Q236 245 207 244 Q204 237 213 230 Q233 221 229 199Z" fill="url(#wing)"/>
</g>'''
cover=defs+'''<rect width="640" height="320" rx="28" fill="url(#night)"/>
<circle cx="324" cy="154" r="127" fill="#fff2bc" opacity=".10"/><circle cx="324" cy="154" r="105" fill="#fff2bc" opacity=".09"/>
<path d="M0 256 Q88 186 184 260 T361 260 T548 239 Q607 218 640 231 V320 H0Z" fill="#256d6c"/>
<path d="M0 284 Q116 247 190 289 T388 282 T640 271 V320 H0Z" fill="#194e59"/>
<path d="M0 311 Q70 273 152 307 M640 313 Q560 267 489 308" stroke="#4c9b88" stroke-width="3" fill="none"/>
<path d="M35 291 Q68 264 56 250 Q36 251 35 291 M62 288 Q96 277 101 257 Q79 257 62 288 M579 289 Q559 264 563 252 Q584 251 579 289 M606 299 Q577 285 593 264 Q608 269 606 299" fill="#68b39a"/>
<path d="M88 97 Q106 62 145 81 Q166 86 178 104 Q143 120 88 97Z M483 118 Q502 93 526 106 Q551 98 569 119 Q541 140 483 118Z" fill="#b8e3d8" opacity=".25"/>
'''+''.join(spark(*v) for v in [(88,63,.8),(157,143,.9),(196,45,.55),(477,58,1.05),(540,197,.85),(587,78,.65),(111,210,.55),(445,132,.45)])+'<g transform="translate(163 12)">'+owl+'</g>'
render(root/'assets/images/tiko_cover.png',cover,'0 0 640 320',1280,640)
icon=defs+'<rect width="320" height="320" rx="66" fill="url(#night)"/><circle cx="160" cy="161" r="121" fill="#69c6ac" opacity=".18"/>'+spark(60,92,.61)+spark(264,96,.76)+owl
app=root/'assets/images/app_icon.png'
render(app,icon,'0 0 320 320',512,512)
for density,side in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    Image.open(app).resize((side,side),Image.Resampling.LANCZOS).save(res/f'mipmap-{density}/ic_launcher.png')
render(res/'drawable-nodpi/tiko_launcher_foreground.png',defs+'<g transform="translate(44 42) scale(.725)">'+owl+'</g>','0 0 320 320',432,432)
