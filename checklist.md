# Checklist de Pruebas Estáticas (IEEE 1028) – Auditoría C# + DevOps

**Proyecto:** Auditoría Estática  
**Norma base:** IEEE 1028 (técnicas estáticas: revisión/inspección)  
**Objetivo:** Control preventivo automatizable sin frenar el pipeline CI/CD.

> **Cómo usar:** Marcar **Cumple / No cumple / N/A**, y anotar **Evidencia** (archivo/línea, captura o salida del pipeline).

---

## 0) Metadatos de auditoría
- **Repositorio / Rama:** ______________________
- **Fecha:** ______________________
- **Auditor(es):** ______________________
- **Stack:** .NET ____ / C# ____ / SO runner: ____
- **Herramientas previstas:** analyzers / linter / script / GH Actions

---

## 1) Estándares de código (C# / .NET)
| ID | Control | Cumple | No cumple | N/A | Evidencia | Severidad |
|---|---|---|---|---|---|---|
| COD-01 | Compila sin errores y sin warnings críticos | ☐ | ☐ | ☐ | | Alta |
| COD-02 | `TreatWarningsAsErrors=true` en `.csproj` (o equivalente) | ☐ | ☐ | ☐ | | Media |
| COD-03 | Nombres claros: clases PascalCase, métodos PascalCase, variables camelCase | ☐ | ☐ | ☐ | | Baja |
| COD-04 | No hay “magic numbers/strings” (usar constantes/enums) | ☐ | ☐ | ☐ | | Media |
| COD-05 | No hay código muerto/comentado | ☐ | ☐ | ☐ | | Baja |
| COD-06 | No se usa `var` de forma confusa (solo cuando es evidente) | ☐ | ☐ | ☐ | | Baja |
| COD-07 | Uso correcto de `using`/`IDisposable` (sin fugas de recursos) | ☐ | ☐ | ☐ | | Alta |
| COD-08 | No se usan APIs obsoletas/deprecadas | ☐ | ☐ | ☐ | | Media |

---

## 2) Seguridad básica (entrada, errores, exposición)
| ID | Control | Cumple | No cumple | N/A | Evidencia | Severidad |
|---|---|---|---|---|---|---|
| SEC-01 | Validación de entradas del usuario (no confiar en `Console.ReadLine()`/inputs) | ☐ | ☐ | ☐ | | Alta |
| SEC-02 | Conversión segura (`int.TryParse`, etc.) en vez de `Parse` directo | ☐ | ☐ | ☐ | | Alta |
| SEC-03 | Manejo de excepciones en puntos críticos (try/catch + respuesta controlada) | ☐ | ☐ | ☐ | | Alta |
| SEC-04 | No se exponen mensajes internos sensibles (stack traces, rutas) al usuario final | ☐ | ☐ | ☐ | | Media |
| SEC-05 | No hay secretos en el repo (keys/tokens/passwords en texto plano) | ☐ | ☐ | ☐ | | Alta |
| SEC-06 | Dependencias seguras (sin paquetes vulnerables conocidos) | ☐ | ☐ | ☐ | | Alta |
| SEC-07 | Principio de mínimo privilegio (no ejecutar como admin sin necesidad) | ☐ | ☐ | ☐ | | Media |

---

## 3) Mantenibilidad y calidad interna
| ID | Control | Cumple | No cumple | N/A | Evidencia | Severidad |
|---|---|---|---|---|---|---|
| MAIN-01 | Funciones cortas y con responsabilidad clara (evitar “god method”) | ☐ | ☐ | ☐ | | Media |
| MAIN-02 | Complejidad baja (evitar ifs anidados excesivos; usar guard clauses) | ☐ | ☐ | ☐ | | Media |
| MAIN-03 | Separación de capas (UI/servicios/datos) cuando aplica | ☐ | ☐ | ☐ | | Media |
| MAIN-04 | No hay duplicación evidente (DRY) | ☐ | ☐ | ☐ | | Media |
| MAIN-05 | Mensajes y textos centralizados si crece la app (evitar repetición) | ☐ | ☐ | ☐ | | Baja |
| MAIN-06 | Configuración por `appsettings`/variables, no hardcode | ☐ | ☐ | ☐ | | Alta |

---

## 4) Documentación mínima
| ID | Control | Cumple | No cumple | N/A | Evidencia | Severidad |
|---|---|---|---|---|---|---|
| DOC-01 | README con: objetivo, cómo correr, requisitos, comandos | ☐ | ☐ | ☐ | | Media |
| DOC-02 | Comentarios XML en APIs públicas/clases clave (si aplica) | ☐ | ☐ | ☐ | | Baja |
| DOC-03 | Registro de auditoría: hallazgos + riesgos + recomendaciones | ☐ | ☐ | ☐ | | Alta |
| DOC-04 | Evidencia de uso de IA: prompt + respuesta + qué se aplicó | ☐ | ☐ | ☐ | | Media |

---

## 5) Buenas prácticas específicas C#
| ID | Control | Cumple | No cumple | N/A | Evidencia | Severidad |
|---|---|---|---|---|---|---|
| CS-01 | Uso de `nullable`/validación de nulls cuando corresponde | ☐ | ☐ | ☐ | | Media |
| CS-02 | `async/await` correcto (si aplica) sin `.Result`/deadlocks | ☐ | ☐ | ☐ | | Alta |
| CS-03 | Logs en vez de solo `Console.WriteLine` (si aplica a entorno real) | ☐ | ☐ | ☐ | | Media |
| CS-04 | No hay `catch (Exception)` vacío (sin registrar ni actuar) | ☐ | ☐ | ☐ | | Alta |
| CS-05 | Control de errores consistente (mensajes y flujos claros) | ☐ | ☐ | ☐ | | Media |

---

## 6) Cumplimiento DevOps (CI/CD y calidad preventiva)
| ID | Control | Cumple | No cumple | N/A | Evidencia | Severidad |
|---|---|---|---|---|---|---|
| DEVOPS-01 | GitHub Actions ejecuta auditoría en `push` y `pull_request` | ☐ | ☐ | ☐ | | Alta |
| DEVOPS-02 | El pipeline falla si el script detecta incumplimientos | ☐ | ☐ | ☐ | | Alta |
| DEVOPS-03 | Se genera reporte automático (archivo/artefacto/log) | ☐ | ☐ | ☐ | | Media |
| DEVOPS-04 | `dotnet restore` + `dotnet build` sin interactive steps | ☐ | ☐ | ☐ | | Media |
| DEVOPS-05 | Reglas de calidad aplicadas antes de merge (gating) | ☐ | ☐ | ☐ | | Alta |

---

## 7) Resultado final de auditoría
- **Estado:** ☐ Aprobado ☐ Rechazado ☐ Aprobado con observaciones  
- **Hallazgos críticos (Alta):** ____  
- **Hallazgos medios:** ____  
- **Hallazgos bajos:** ____  

**Observaciones del auditor:**  
- ____________________________________________
- ____________________________________________

