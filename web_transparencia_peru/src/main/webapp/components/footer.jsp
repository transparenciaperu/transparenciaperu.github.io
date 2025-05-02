<%-- 
  Common footer component with shared scripts and copyright information
  Use this in all panel pages to maintain consistency
--%>

<!-- Footer -->
<footer class="footer py-3 mt-5 bg-light border-top">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-6 small text-muted">
                &copy; <%= java.time.Year.now().getValue() %> Portal de Transparencia Perú | Todos los derechos
                reservados
            </div>
            <div class="col-md-6 text-md-end small">
                <a href="#" class="text-decoration-none text-muted me-3">Términos de Uso</a>
                <a href="#" class="text-decoration-none text-muted me-3">Política de Privacidad</a>
                <a href="#" class="text-decoration-none text-muted">Contacto</a>
            </div>
        </div>
    </div>
</footer>

<!-- Common Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

<!-- Common Initialization Script -->
<script>
    // Initialize tooltips across the site
    $(document).ready(function () {
        // Initialize Bootstrap tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Add fade-in animations to elements
        $('.fade-in-element').addClass('fade-in');

        // Initialize standard DataTables
        if ($.fn.DataTable && $('.data-table').length > 0) {
            $('.data-table').DataTable({
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
                },
                pageLength: 10,
                lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Todos"]],
                responsive: true
            });
        }
    });
</script>