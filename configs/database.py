import sqlite3

class Database:
    def __init__(self):
        self.db_name = 'db/app.db'
        self.connection = None

    def connect(self):
        """Establecer una conexión a la base de datos."""
        if self.connection is None:
            self.connection = sqlite3.connect(self.db_name)
            self.connection.row_factory = sqlite3.Row  # Permite acceder a las columnas por nombre
            print("Conexión establecida.")

    def close(self):
        """Cerrar la conexión a la base de datos."""
        if self.connection:
            self.connection.close()
            self.connection = None
            print("Conexión cerrada.")

    def execute(self, query, params=()):
        """Ejecutar una consulta SQL."""
        self.connect()  # Asegúrate de estar conectado
        cursor = self.connection.cursor()
        cursor.execute(query, params)
        self.connection.commit()
        return cursor

    def fetchall(self, query, params=()):
        """Ejecutar una consulta SQL y devolver todos los resultados."""
        cursor = self.execute(query, params)
        return cursor.fetchall()

    def fetchone(self, query, params=()):
        """Ejecutar una consulta SQL y devolver un único resultado."""
        cursor = self.execute(query, params)
        return cursor.fetchone()