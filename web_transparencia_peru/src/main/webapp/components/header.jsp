<%-- 
  Common header component with shared meta tags and CSS/JS imports
  Use this in all panel pages to maintain consistency
--%>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Portal de Transparencia Perú - Acceso a la información pública">
<meta name="author" content="Gobierno del Perú">

<!-- Favicon -->
<link rel="icon" href="<%= request.getContextPath() %>/assets/img/favicon.ico" type="image/x-icon">

<!-- Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

<!-- CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">

<!-- Preload essential JavaScript -->
<link rel="preload" href="https://code.jquery.com/jquery-3.7.0.min.js" as="script">
<link rel="preload" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" as="script">