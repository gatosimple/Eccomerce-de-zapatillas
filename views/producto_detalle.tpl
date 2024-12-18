<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/styles.css">
    <title>{{ producto['nombre'] }} - Detalles</title>
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

    <div class="product-detail-container">
        <div class="product-main">
            <div class="product-image">
                <img src="{{ producto['foto'] }}" alt="Foto de {{ producto['nombre'] }}">
            </div>
            
            <div class="product-info">
                <div class="product-title-stock">
                    <h1>{{ producto['nombre'] }}</h1>
                    <span class="stock-number">#{{ producto['stock'] }}</span>
                </div>
                <div class="product-specs">
                    <p><strong>Modelo:</strong> {{ producto['modelo'] }}</p>
                    <p class="price"><strong>Precio:</strong> S/.{{ producto['precio'] }}</p>
                    <p><strong>Código:</strong> {{ producto['codigo'] }}</p>
                    <p><strong>Ancho:</strong> {{ producto['ancho'] }} cm</p>
                    <p><strong>Estilo:</strong> {{ estilos['nombre'] }}</p>
                    <p><strong>Temporada:</strong> {{ temporadas['nombre'] }}</p>
                    <p><strong>Género:</strong> {{ generos['nombre'] }}</p>
                </div>

                <div class="product-selection">
                    <div class="color-selection">
                        <h2>Colores Disponibles</h2>
                        <form action="/producto/{{ producto['id'] }}" method="post" class="color-options">
                            % if colores_disponibles:
                                % for color in colores_disponibles:
                                <label class="color-option">
                                    <input type="radio" name="color" value="{{ color['color_id'] }}" onchange="this.form.submit()"
                                    % if color_seleccionado and color['color_id'] == int(color_seleccionado):
                                        checked
                                    % end
                                    >
                                    <span>{{ color['nombre'] }}</span>
                                </label>
                                % end
                            % else:
                                <p class="no-available">No hay colores disponibles</p>
                            % end
                        </form>
                    </div>

                    <div class="size-selection">
                        <h2>Tallas Disponibles</h2>
                        <form action="/producto/{{ producto['id'] }}" method="post" class="size-options">
                            <input type="hidden" name="color" value="{{ color_seleccionado }}">
                            % if tallas_disponibles:
                                % for talla in tallas_disponibles:
                                <label class="size-option">
                                    <input type="radio" name="talla" value="{{ talla['talla_id'] }}" 
                                    onchange="this.form.submit()"
                                    % if talla_seleccionada and talla['talla_id'] == int(talla_seleccionada):
                                        checked
                                    % end
                                    % if talla['stock'] == 0:
                                        disabled
                                    % end
                                    >
                                    <span>Perú: {{ talla['peru'] }} | US: {{ talla['us'] }} | CM: {{ talla['cm'] }} <span class="stock-number">#{{ talla['stock'] }}</span></span>
                                </label>
                                % end
                            % else:
                                <p class="no-available">Seleccione un color</p>
                            % end
                        </form>
                    </div>

                    <form action="/agregar_al_carrito" method="post" class="add-to-cart">
                        <input type="hidden" name="producto_id" value="{{ producto['id'] }}">
                        <input type="hidden" name="producto_color_talla_id" value="{{ producto_color_talla_id }}">
                        <div class="quantity-selector">
                            <label for="cantidad">Cantidad:</label>
                            <input type="number" name="cantidad" id="cantidad" value="1" min="1">
                        </div>
                        <button type="submit" class="add-cart-btn">Agregar al Carrito</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="product-details">
            <div class="details-section">
                <h2>Actividades</h2>
                <ul class="details-list">
                    % if actividades:
                        % for actividad in actividades:
                        <li>{{ actividad['nombre'] }}</li>
                        % end
                    % else:
                        <li class="no-items">No hay actividades asociadas</li>
                    % end
                </ul>
            </div>

            <div class="details-section">
                <h2>Colaboraciones</h2>
                <ul class="details-list">
                    % if colaboraciones:
                        % for colaboracion in colaboraciones:
                        <li>{{ colaboracion['nombre'] }}</li>
                        % end
                    % else:
                        <li class="no-items">No hay colaboraciones asociadas</li>
                    % end
                </ul>
            </div>

            <div class="details-section">
                <h2>Materiales</h2>
                <ul class="details-list">
                    % if materiales:
                        % for material in materiales:
                        <li>{{ material['nombre'] }}</li>
                        % end
                    % else:
                        <li class="no-items">No hay materiales asociados</li>
                    % end
                </ul>
            </div>

            <div class="details-section">
                <h2>Tecnologías</h2>
                <ul class="details-list">
                    % if tecnologias:
                        % for tecnologia in tecnologias:
                        <li>{{ tecnologia['nombre'] }}</li>
                        % end
                    % else:
                        <li class="no-items">No hay tecnologías asociadas</li>
                    % end
                </ul>
            </div>
        </div>

        <div class="comments-section">
            <h2>Comentarios</h2>
            <div class="comments-list">
                % if comentarios:
                    % for comentario in comentarios:
                    <div class="comment">
                        <div class="comment-header">
                            <span class="comment-author">{{ comentario['nombre'] }} {{ comentario['apellido'] }}</span>
                            <span class="comment-type">{{ comentario['tipo_comentario'] }}</span>
                        </div>
                        <p class="comment-text">{{ comentario['mensaje'] }}</p>
                    </div>
                    % end
                % else:
                    <p class="no-comments">No hay comentarios para este producto</p>
                % end
            </div>
        </div>
    </div>

    <footer>
        <p>&copy; 2024 Runner's Choice. Todos los derechos reservados.</p>
    </footer>
</body>
</html>
