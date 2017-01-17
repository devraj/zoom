## Zoom Suite 6

Zoom Suite is a point of sale and business management system for photography laboratories. It was originally written for my dad's business (The Photo Makers, who operated numerous stored around [Patna](https://en.wikipedia.org/wiki/Patna) a major city in [India](https://en.wikipedia.org/wiki/India)) by one of his colleagues and rebooted in the mid nineties by me to feature a better user interface and operate over a network.

The project originally a commercial interest but was later branded as an in-house project. I ceased to maintain it post the nineties as I moved away to pursue my career and stopped working with xBase variants.

The product as built using [FoxPro](https://en.wikipedia.org/wiki/FoxPro) a now defunct xBase variant.

During the later (1998-1999) years I attempted to export data from the FoxPro databases and send it across to an external web server where a PHP application would allow customers 

### Purpose

This repository is an attempt to keep the source code that I spent many years building and maintaining as a relic of my earlier work. Zoom has no practical use and is being published here for purely academic purposes. I intend to document my thoughts on design and the environment.

### Data

The data files are missing at present, I am cleaning them up and will leave detailed instructions on how the backend worked. There's a [Python library](http://pythonhosted.org/dbf/) that can speak the original [DBF](https://en.wikipedia.org/wiki/.dbf) file format in case you would be interested in inspecting the data. 

## Features

The photography lab provided the following services:

- Sales of cameras, films and accessories
- Processing of films and printing photographs (various sizes) 
- Specialist processing such as [E-6](https://en.wikipedia.org/wiki/E-6_process)

The business had direct customers (along with a loyal program) and agents (satellite businesses that would bring bulk work for processing and would be given a better price).

Zoom was a multi user system with authorization. It features extensive reporting for the business (most printed on [dot matrix printers](https://en.wikipedia.org/wiki/Dot_matrix_printing)).