# Ajustes no projeto Android gerado pelo Capacitor:
# 1) link de retorno do login com Google (com.nazareno.oficial://)
# 2) tela cheia (esconde a barra de status)
import os, re

man = 'android/app/src/main/AndroidManifest.xml'
s = open(man, encoding='utf-8').read()
if 'android:scheme="com.nazareno.oficial"' not in s:
    filt = '''            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="com.nazareno.oficial" />
            </intent-filter>
'''
    s = s.replace('</activity>', filt + '        </activity>', 1)
    open(man, 'w', encoding='utf-8').write(s)
    print('AndroidManifest: link de retorno adicionado')

sty = 'android/app/src/main/res/values/styles.xml'
if os.path.exists(sty):
    t = open(sty, encoding='utf-8').read()
    if 'windowFullscreen' not in t:
        t2 = re.sub(r'(<style name="AppTheme\.NoActionBar"[^>]*>)', r'\1\n        <item name="android:windowFullscreen">true</item>', t, count=1)
        if t2 != t:
            open(sty, 'w', encoding='utf-8').write(t2)
            print('styles.xml: tela cheia ligada')
