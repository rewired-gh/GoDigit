# GoDigit <img src="./Assets/SSC2024_Social_Static_1x1.jpg" align="right" width="100" alt="Swift Student Challenge Winner"></img>

> [!NOTE]
> This repository is archived. For the latest and improved app, please refer to [rewired-gh/BitLab](https://github.com/rewired-gh/BitLab).

## Introduction

GoDigit is an app that serves both as a toolbox for tinkering with representations of numbers in computers and as a source of accompanying learning content. It offers tools for debugging simulation waveforms, examining numbers within memory regions, and acquiring practical knowledge about computer systems.

This app is one of the winner of the Swift Student Challenge 2024. More features are planned to be added in the future.

## Key features

### Tools

- Integer converter: Convert integer number to other forms. It is useful for exploring how integer numbers are stored in computers.

- Bits extractor: Extract binary bits and convert segments to readable hexadecimal. It is useful for perceiving the value of each segment.

- Float inspector: Inspect the raw representaion of floating-point numbers. It is useful for understanding the implementation of IEEE 754.

### Learning Content

- Number and radix: Learn what is a radix and how to convert between radices. It covers three commonly-used radices.

- Integer in computer: Learn how integer numbers are stored in computers. It covers the basics of two's complement.

## Motivation

When I was learning Computer Organization, I felt the explanations from the lecturer were not intuitive. I wasted excessive amounts of time checking whether my homework answers were correct. Furthermore, in the process of verifying and debugging my CPU design, I was often forced to manually split a multi-bit signal unless debug signals were specifically defined.

So I want to develop an app in hope of help students in learning courses related to computer systems. And bring computer engineers a truly convenient set of tools.

## Development Setup

This is an Xcode Swift Playground project.
