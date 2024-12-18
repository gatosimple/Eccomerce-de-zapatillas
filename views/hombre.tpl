<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productos Masculinos</title>
    <link rel="stylesheet" href="/static/styles.css">
</head>
<body>
    <header>
        <nav>
            <a href="/">Inicio</a>
            <a href="/mujer">Mujer</a>
            <a href="/hombre">Hombre</a>
            <a href="/estilos">Estilos</a>
            <a href="/contacto">Nosotros</a>
            <a href="/carrito">Carrito</a>
            <a href="/pedidos">Pedidos</a>
            % if cliente and cliente['genero_id'] == 1:
            <span>Bienvenido, {{ cliente['nombre'] }} | <a href="/logout">Cerrar Sesión</a></span>
            % elif cliente and cliente['genero_id'] == 2:
            <span>Bienvenida, {{ cliente['nombre'] }} | <a href="/logout">Cerrar Sesión</a></span>
            % else:
            <a href="/login">Iniciar Sesión</a>
            % end
            <a href="/agregar_talla">Agregar Talla</a>
        </nav>
    </header>
    <div class="banner">
        <h1>Productos para Hombre</h1>
        <p>Descubre nuestra colección masculina</p>
    </div>

    <div class="catalog-table">
        % for producto in productos:
        <div class="product-item">
            <img src="{{ producto['foto'] }}" class="product-image" alt="Foto de {{ producto['nombre'] }}">
            <div class="product-info">
                <div class="product-name product-title-stock">
                    <a href="/producto/{{ producto['id'] }}">{{ producto['nombre'] }}</a>
                    <span class="stock-number">#{{ producto['stock'] }}</span>
                </div>
                <div class="product-details">Modelo: {{ producto['modelo'] }}</div>
                <div class="product-details">Género: Masculino</div>
                <div class="product-price">S/. {{ producto['precio'] }}</div>
            </div>
        </div>
        % end
    </div>
    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>

