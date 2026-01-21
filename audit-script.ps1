# audit-script.ps1
# Auditoría estática simple (IEEE 1028) para C# + DevOps
# - Ejecuta build con analyzers
# - Busca patrones de riesgo comunes
# - Genera audit-report.md
# - Devuelve exit 1 si hay hallazgos de severidad alta/media

$ErrorActionPreference = "Stop"

Write-Host "== Auditoría Estática (IEEE 1028) =="

# 1) Encontrar .csproj
$csproj = Get-ChildItem -Recurse -Filter *.csproj | Select-Object -First 1
if (-not $csproj) {
  Write-Host "❌ No se encontró ningún archivo .csproj en el repositorio."
  exit 2
}

Write-Host "✅ Proyecto detectado: $($csproj.FullName)"

# 2) Build con analyzers (control preventivo)
Write-Host "== dotnet restore =="
dotnet restore $csproj.FullName

Write-Host "== dotnet build (con analyzers) =="
# TreatWarningsAsErrors suele estar en el csproj; aquí solo forzamos build.
dotnet build $csproj.FullName --no-restore

# 3) Reglas simples por patrones (puedes ampliar luego)
Write-Host "== Análisis por patrones =="
$hallazgos = @()

# Tomar archivos .cs (evitar bin/obj)
$csFiles = Get-ChildItem -Recurse -Filter *.cs |
  Where-Object { $_.FullName -notmatch "\\bin\\" -and $_.FullName -notmatch "\\obj\\" }

if (-not $csFiles) {
  Write-Host "⚠️ No se encontraron archivos .cs para analizar."
}

function Add-Finding($id, $titulo, $severidad, $detalle) {
  $hallazgos += [PSCustomObject]@{
    ID = $id
    Titulo = $titulo
    Severidad = $severidad
    Detalle = $detalle
  }
}

foreach ($f in $csFiles) {
  $content = Get-Content $f.FullName -Raw

  # SEC-02: int.Parse / double.Parse / decimal.Parse (riesgo si no hay validación)
  if ($content -match "\b(int|double|decimal)\.Parse\s*\(") {
    Add-Finding "SEC-02" "Uso de Parse directo (riesgo de excepción y entrada inválida)" "Alta" "Archivo: $($f.FullName) - Reemplazar por TryParse + validación."
  }

  # SEC-01: uso de Console.ReadLine sin validación (heurística)
  if ($content -match "Console\.ReadLine\s*\(" -and $content -notmatch "TryParse") {
    Add-Finding "SEC-01" "Entrada sin validación (Console.ReadLine sin TryParse)" "Alta" "Archivo: $($f.FullName) - Validar entrada antes de procesar."
  }

  # SEC-03: ausencia de try/catch (heurística muy básica)
  if ($content -match "Main\s*\(" -and $content -notmatch "try\s*\{") {
    Add-Finding "SEC-03" "Falta manejo de excepciones en flujo principal" "Media" "Archivo: $($f.FullName) - Agregar try/catch con respuesta controlada."
  }

  # DOC-02: falta de comentarios XML (si es proyecto pequeño, lo marcamos como baja)
  if ($content -notmatch "///") {
    Add-Finding "DOC-02" "Poca documentación en código (sin comentarios XML)" "Baja" "Archivo: $($f.FullName) - Agregar doc básica en métodos/clases principales."
  }

  # DEVOPS: no hay logging (heurística)
  if ($content -match "Console\.WriteLine" -and $content -notmatch "ILogger") {
    Add-Finding "CS-03" "Uso de Console.WriteLine en vez de logging" "Baja" "Archivo: $($f.FullName) - Considerar logging (ILogger) si escala."
  }
}

# 4) Generar audit-report.md
Write-Host "== Generando audit-report.md =="

$fecha = Get-Date -Format "yyyy-MM-dd HH:mm"
$report = @()
$report += "# Informe de Auditoría Estática (IEEE 1028)"
$report += ""
$report += "**Fecha:** $fecha"
$report += "**Proyecto:** $($csproj.Name)"
$report += ""
$report += "## Hallazgos"
$report += ""

if ($hallazgos.Count -eq 0) {
  $report += "✅ No se detectaron hallazgos por reglas automatizadas."
} else {
  $report += "| ID | Hallazgo | Severidad | Evidencia / Recomendación |"
  $report += "|---|---|---|---|"
  foreach ($h in $hallazgos) {
    $report += "| $($h.ID) | $($h.Titulo) | $($h.Severidad) | $($h.Detalle) |"
  }
}

$report += ""
$report += "## Riesgos (resumen)"
$report += "- **Alta:** Posibles fallos por entrada inválida y caídas por excepciones."
$report += "- **Media:** Falta de control de errores en flujo principal."
$report += "- **Baja:** Falta de documentación/logging (impacta mantenimiento)."
$report += ""
$report += "## Recomendaciones"
$report += "1. Reemplazar `Parse` por `TryParse` + validación."
$report += "2. Implementar `try/catch` en flujo principal y respuestas controladas."
$report += "3. Agregar documentación mínima (README + comentarios claves)."
$report += "4. Mantener auditoría en CI/CD para frenar merges con fallos."
$report += ""

Set-Content -Path "audit-report.md" -Value $report -Encoding UTF8

Write-Host "✅ Reporte generado: audit-report.md"

# 5) Decidir si falla el pipeline
$altos = ($hallazgos | Where-Object { $_.Severidad -eq "Alta" }).Count
$medios = ($hallazgos | Where-Object { $_.Severidad -eq "Media" }).Count

if ($altos -gt 0 -or $medios -gt 0) {
  Write-Host "❌ Auditoría FALLA: Hallazgos Alta=$altos, Media=$medios"
  exit 1
}

Write-Host "✅ Auditoría OK: sin hallazgos Alta/Media"
exit 0
