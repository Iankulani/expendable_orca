#!/usr/bin/env python3
"""
EXPENDABLE_ORCA v4.0.0 - Setup Script
Author: Ian Carter Kulani
"""

from setuptools import setup, find_packages
import os
import sys

def read_requirements():
    """Read requirements from file"""
    try:
        with open('requirements.txt', 'r') as f:
            return [line.strip() for line in f if line.strip() and not line.startswith('#')]
    except:
        return []

setup(
    name="expendable-orca",
    version="4.0.0",
    description="Ultimate Cybersecurity Command & Control Platform",
    long_description=open('README.md', 'r').read() if os.path.exists('README.md') else "",
    long_description_content_type="text/markdown",
    author="Ian Carter Kulani",
    url="https://github.com/iankulani/expendable-orca",
    packages=find_packages(),
    include_package_data=True,
    install_requires=read_requirements(),
    entry_points={
        'console_scripts': [
            'expendable-orca=expendable_orca:main',
        ],
    },
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Information Technology",
        "Intended Audience :: System Administrators",
        "License :: Other/Proprietary License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Topic :: Security",
        "Topic :: System :: Networking :: Monitoring",
    ],
    python_requires=">=3.7",
    license="Proprietary - For authorized security testing only",
)