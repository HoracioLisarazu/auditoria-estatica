# Informe de Auditoría Estática (IEEE 1028)

## 1. Información General
- **Proyecto:** DemoAuditApp
- **Lenguaje:** C# (.NET 8)
- **Tipo de Auditoría:** Pruebas Estáticas Automatizadas
- **Norma:** IEEE 1028
- **Entorno:** GitHub Actions (CI/CD)
- **Resultado:** ❌ No conforme (pipeline bloqueado)

---

## 2. Resumen Ejecutivo
Se ejecutó una auditoría estática automática integrada al pipeline CI/CD.  
El sistema detectó defectos intencionales de seguridad y calidad, provocando el fallo del pipeline como mecanismo de **control preventivo**, evitando que código defectuoso avance a producción.

---

## 3. Hallazgos Detectados

| ID | Hallazgo | Severidad | Evidencia | Riesgo |
|----|---------|-----------|----------|--------|
| SEC-02 | Uso de `int.Parse()` sin validación | Alta | `Program.cs` | Caída del sistema por entrada inválida |
| SEC-01 | Entrada del usuario sin validación | Alta | `Console.ReadLine()` | Datos incorrectos afectan la lógica |
| SEC-03 | Falta de manejo de excepciones | Media | Método `Main()` | Errores no controlados |
| DOC-02 | Ausencia de documentación | Baja | Código sin comentarios | Dificulta mantenimiento |

---

## 4. Análisis de Riesgos
- **Disponibilidad:** la aplicación puede fallar ante entradas inválidas.
- **Confiabilidad:** ausencia de control de errores.
- **Mantenibilidad:** sin documentación técnica.

---

## 5. Recomendaciones
1. Reemplazar `int.Parse()` por `int.TryParse()`.
2. Validar todas las entradas del usuario.
3. Implementar bloques `try/catch`.
4. Agregar documentación mínima.
5. Mantener auditoría automática en CI/CD.

---

## 6. Evidencia DevOps
- Workflow: `.github/workflows/audit.yml`
- Script: `audit-script.ps1`
- Resultado: **Pipeline bloqueado por hallazgos críticos**
