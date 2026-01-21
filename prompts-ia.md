# Evidencia de Uso de IA Generativa – Auditoría Estática (IEEE 1028)

## Prompt utilizado
Actúa como auditor de sistemas y experto en IEEE 1028.
Necesito un checklist de pruebas estáticas para auditar una aplicación C#.
El checklist debe evaluar estándares de código, seguridad básica,
mantenibilidad, documentación y buenas prácticas DevOps.
Luego convierte el checklist en reglas automatizables para un script PowerShell.

## Respuesta de la IA (resumen)
La IA generó un checklist estructurado por categorías y propuso automatizar
los controles mediante analyzers de .NET, scripts PowerShell y CI/CD.

## Aplicación práctica
- Se creó `checklist.md` basado en IEEE 1028.
- Se implementó `audit-script.ps1` para auditoría automática.
- Se integró el proceso en GitHub Actions.
- El pipeline bloquea el merge cuando existen hallazgos críticos.
