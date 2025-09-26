# SI2-ActivosFijos-Presupuestos
Proyecto Final SI2 2-2025

CREAR BASE DE DATOS EN POSTGRESQL CON EL NOMBRE "ActFijoPresupuesto"
CAMBIAR DEL ARCHIVO .env LO SIGUIENTE:
    'USER': 'nombre_usuario_postgresql',     
    'PASSWORD': 'contraseña_postgresql',
Y HAY QUE CAMBIARLO A LO QUE TENGAN USTEDES

CON LA BD CREADA, TIENE QUE INSTALAR UN ENTORNO VIRTUAL "py -m venv venv" Y ACTIVAR EL ENTORNO VIRTUAL CON "venv\Scripts\activate" 
(Ejecutar sin las comillas xd)

ADENTRO DEL ENTORNO VIRTUAL EJECUTAR "pip install -r requirements.txt" PARA INSTALAR LIBRERIAS DE PYTHON (Todo adentro del entorno virtual)

LUEGO CREAR MIGRARCIONES:
python manage.py makemigrations

LUEGO APLICAR MIGRACIONES:
python manage.py migrate

LUEGO CREAR SUPERUSUARIO:
python manage.py createsuperuser

USER, CORREO Y CONTRASEÑA (Esto es para logearse como superusuario)

LUEGO CORRER EL BACKEND CON EL ENTRONO VIRTUAL ACTIVADO
python manage.py runserver


CON EL FRONTEND SOLO ES COLOCAR "npm install" Y SE INSTALAN LAS DEPENDENCIAS Y PARA CORRER EL FRONT ES COLOCAR "npm run dev"