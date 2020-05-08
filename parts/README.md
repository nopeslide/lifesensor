# LifeSensor parts
*Parts* are components which are used as building blocks of [*products*](../products/README.md).

---
## List of parts
- [interconnect](./interconnect/README.md)
  - interconnect between pcbs

---
## Adding new parts
- If you want to add a new part,
please copy and modify the [*template part*](./.template/README.md)

---
## Structure

```
.
├── README.md              : mandatory README.md you are currently reading
├── Makefile               : mandatory Makefile executing targets in all subdirs
│
├── <part name>            : mandatory unique name of the part
│   ├── README.md          : mandatory general description of the part
│   │                        and elaboration of differences between version
│   │
│   ├── <part version>     : mandatory unique part version
│   │   ├── README.md      : mandatory version specific description of the part,
│   │   │                    should list all features
│   │   │
│   │   ├── Makefile       : mandatory Makefile for integration of the part
│   │   │
│   │   ├── code           : optional parent directory of any source code and build system files
│   │   │   │                i.e. firmware
│   │   │   ├── README.md  : description of the source code
│   │   │   └── ...
│   │   │
│   │   ├── docs           : optional parent directory for documents
│   │   │   │                i.e. documentation, datasheets
│   │   │   ├── README.md  : description of documents
│   │   │   └── ...
│   │   │
│   │   ├── kicad          : optional parent directory for kicad files
│   │   │   │                i.e. project files, schematics
│   │   │   ├── README.md  : description of the kicad files
│   │   │   └── ...
│   │   │
│   │   ├── mechanics      : optional parent directory for mechanic files
│   │   │   │                i.e. 3D-printer models
│   │   │   ├── README.md  : description of the mechanics files
│   │   │   └── ...
│   │   │
│   │   ├── requirements   : mandatory parent directory for requirements
│   │   │   │                used by requirement management tools
│   │   │   ├── README.md  : description of requirements
│   │   │   └── ...
│   │   │
│   │   └── scripts        : optional parent directory of part specific helper scripts
│   │       │                i.e. documentation generation, calculators
│   │       ├── README.md  : description of scripts
│   │       └── ...
│   │
│   ├── <part version>
│   │   └── ...
│   └── ...
│
├── <part name>
│   └── ...
└── ...
```

- *Parts* of the LifeSensor project should have a dedicated directory here.
- *Parts* should not include other *parts*, instead they should refer to other *parts*.
- *Parts* may compete for the same functionality.
  - Different [*products*](../products/README.md) may choose different *parts*
- *Parts* should follow the directory scheme defined by the [*template part*](./.template/README.md)
  - *Parent directories* may contain any structure
  - Optional *parent directories* can be removed
- Only non-breaking changes may be introduced as patch for a *part*
- *Part versions* denote non-backwards-compatible variants of the same *part*
  - If major implementations change, consider creating a new *part* or *part version*
- *Part versions* should never denote the state of the *part*
  - All *parts* should provide their intended functionality

---
## F.a.q
- Why no hierarchical structure?
  - *Parts* may implement multiple features therefore can't be sorted by distinct features
  - *Parts* may consist of file from multiple categories (*code*, *mechanics*, ...) breaking these up makes things complicated
  - *Parts* may be outsourced in the future and reintegrated vai git submodules
- Why version directories inside git?
  - Git can deduplicate files therefore the internal structure isn't bloated
  - This repo aims to support multiple [*products*](../products/README.md) at once which may require different versions of *parts*