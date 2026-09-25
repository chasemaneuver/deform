# From Deformation Theory to Interactive Visualization: Development of an Application for Engineering Education

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

This repository contains the MATLAB codes developed for the academic project *From Deformation Theory to Interactive Visualization: Development of an Application for Engineering Education*, carried out as part of the final coursework requirements for Aerospace Engineering at Politecnico di Milano.

The project develops **DeForm**, an educational visualization tool for comparing infinitesimal-strain and finite-deformation kinematics. The numerical examples progress from the deformation of a two-dimensional square to image warping, three-dimensional bodies, a position-dependent transformation, a simplified Poisson-effect example, and an interactive three-dimensional model of the letter **M**. The scripts display the reference, infinitesimally deformed, and finitely deformed configurations so that the differences between the two formulations can be examined directly.

The accompanying paper also discusses structural-mechanics concepts through the SpaceX CRS-7 accident as a motivating case study. The codes in this repository are general educational demonstrations; they do not reproduce the launch vehicle, identify the cause of the accident, or constitute a validated structural analysis of that event.

## Project scope

The computational work includes:

- two-dimensional deformation of a square under prescribed rotation, shear, and normal-strain parameters;
- comparison between the displacement-gradient approximation and a finite transformation assembled from rotations, stretches, and shears;
- calculation and comparison of the infinitesimal strain tensor and the Green–Lagrange strain tensor;
- evaluation and visualization of nominal fibre strains;
- inverse mapping and bilinear interpolation for the deformation of a colour image;
- three-dimensional deformation of a cube and of an extruded letter **M**;
- a position-dependent transformation applied to a four-cube assembly;
- a simplified linear-elastic illustration of Poisson contraction under axial loading;
- an animation of the transition between prescribed initial and final deformation parameters;
- an interactive MATLAB interface with sliders for rotations, angular shears, and normal-deformation parameters.

## Kinematic model and limitations

For the infinitesimal formulation, the displacement gradient is decomposed into symmetric and skew-symmetric parts,

$$
\mathbf{H}=\nabla_{\!\mathbf{X}}\mathbf{u}
=\boldsymbol{\varepsilon}+\mathbf{W},
$$

where

$$
\boldsymbol{\varepsilon}
=\frac{1}{2}\left(\mathbf{H}+\mathbf{H}^{\mathsf T}\right),
\qquad
\mathbf{W}
=\frac{1}{2}\left(\mathbf{H}-\mathbf{H}^{\mathsf T}\right).
$$

The finite-deformation examples prescribe a deformation mapping through a deformation gradient $\mathbf{F}$ assembled from rotation, stretch, and shear transformations. The associated Green–Lagrange strain tensor is

$$
\mathbf{E}
=\frac{1}{2}\left(\mathbf{F}^{\mathsf T}\mathbf{F}-\mathbf{I}\right).
$$

The finite transformations are intended to illustrate kinematic differences and the limits of the infinitesimal approximation. Their result depends on the selected parameter definitions and on the order in which the transformations are composed. Except for the position-dependent example, the prescribed mappings are spatially homogeneous.

The repository does not implement a finite-element solver, solve a structural boundary-value problem, enforce equilibrium, or model constitutive nonlinearity, contact, damage, fracture, fatigue evolution, or dynamic failure. The Poisson-effect script is a simplified uniaxial, linear-elastic demonstration. The results are therefore suitable for teaching, visualization, and preliminary comparison, but not for structural certification or accident reconstruction.

## Repository structure

```text
.
|-- Animazione_letteraM.m
|-- Deformazione_cubo_3D.m
|-- Deformazione_funzione_posizione.m
|-- Deformazione_immagine_2D.m
|-- Deformazione_letteraM_3D.m
|-- Deformazioni_quadrato_2D.m
|-- Effetto_Poisson.m
|-- Funzione_DeForm.m
|-- Video_animazione_lettera_M.md
|-- LICENSE
`-- README.md
```

## MATLAB files

| File | Purpose |
|---|---|
| `Deformazioni_quadrato_2D.m` | Compares infinitesimal and finite deformation of a square; evaluates Green–Lagrange strain, fibre strains, rigid-body rotation, axial deformation, and pure shear. |
| `Deformazione_immagine_2D.m` | Applies the two kinematic descriptions to a user-supplied colour image using inverse coordinate mapping and bilinear interpolation. |
| `Deformazione_cubo_3D.m` | Extends the comparison to a cube and reports the difference between finite and infinitesimal strain measures. |
| `Deformazione_funzione_posizione.m` | Applies a position-dependent finite transformation to an assembly of four cubes. |
| `Effetto_Poisson.m` | Illustrates axial extension and lateral contraction of a four-cube wooden assembly under a prescribed static force. |
| `Deformazione_letteraM_3D.m` | Compares the reference, infinitesimally deformed, and finitely deformed configurations of an extruded letter **M**. |
| `Animazione_letteraM.m` | Animates the transition between user-defined initial and final deformation parameters for the letter **M**. |
| `Funzione_DeForm.m` | Provides the interactive DeForm interface, with sliders controlling three rotations, three angular shears, and three normal-deformation parameters. |

## Software requirements

- MATLAB R2016b or later is recommended because some scripts contain local functions;
- Image Processing Toolbox is required for the image-visualization operations in `Deformazione_immagine_2D.m`;
- a user-supplied RGB image is required to run the image-deformation example.

The remaining demonstrations use standard MATLAB numerical, graphics, and user-interface functions.

## Usage

Clone or download the repository:

```bash
git clone https://github.com/chasemaneuver/deform.git
cd deform
```

Open the repository folder in MATLAB and launch the interactive application with:

```matlab
Funzione_DeForm
```

The remaining examples can be run individually from the MATLAB Editor or Command Window:

```matlab
Deformazioni_quadrato_2D
Deformazione_immagine_2D
Deformazione_cubo_3D
Deformazione_funzione_posizione
Effetto_Poisson
Deformazione_letteraM_3D
Animazione_letteraM
```

When `Deformazione_immagine_2D` is started, a file-selection window asks the user to choose the image to be deformed. The original input image is not distributed in this repository; users are responsible for ensuring that any selected image is used under appropriate licensing terms.

Before running a script, review the input section near the beginning of the file and select or modify the desired rotation, shear, strain, material, or loading parameters. Angles are expressed in radians unless otherwise stated. For meaningful comparison, use the infinitesimal formulation only when displacement gradients and rotations remain sufficiently small.

## Supplementary animation

An embedded preview of the letter-**M** deformation animation is available in [`Video_animazione_lettera_M.md`](Video_animazione_lettera_M.md). The corresponding numerical sequence is generated by `Animazione_letteraM.m`.

## Associated publication

The complete paper is being prepared for archival publication. Its DOI should be added here after the Zenodo record has been published:

**DOI:** `PAPER_DOI`

## Citation

If you use the codes, figures, or results contained in this repository, please cite the associated paper after publication:

> M. Vrapi, "From Deformation Theory to Interactive Visualization: Development of an Application for Engineering Education," Zenodo, 2026. doi: `PAPER_DOI`.

Replace `PAPER_DOI` with the DOI assigned to the paper after publication on Zenodo.

## License

The source code in this repository is distributed under the MIT License. See the [`LICENSE`](LICENSE) file for the complete terms. The associated paper and any separately archived supplementary material are distributed under the terms specified in their respective publication records.

## Author

- Michelle Vrapi ([ORCID](https://orcid.org/0009-0007-3304-8042))

Politecnico di Milano, Department of Aerospace Science and Technology (DAER).

## Project context

This repository is associated with an academic aerospace engineering project and is not an official publication of Politecnico di Milano. The codes are shared for documentation, reproducibility, and portfolio purposes.
