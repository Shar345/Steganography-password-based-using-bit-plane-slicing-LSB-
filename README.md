# Steganography-password-based-using-bit-plane-slicing-LSB-

# Steganography using LSB in Image (Password Based Encryption)

## Project Overview

In today’s digital world, secure communication has become very important due to the rapid growth of the internet and multimedia data. Along with encryption, **steganography** plays an important role in information security by hiding secret information inside digital media such as images, audio, and videos.

This project implements **LSB (Least Significant Bit) based image steganography with password-based encryption** to securely hide confidential text data inside an image while maintaining the original image quality.

## How It Works

In this system, the secret text message is first encrypted using a password before being embedded into the image. The password works as a security key, allowing only authorized users to extract and decrypt the hidden message.

Even if an unauthorized person gets access to the stego image, the hidden information remains protected without the correct password.

## LSB Image Steganography

The **Least Significant Bit (LSB)** technique hides data by modifying the least significant bits of image pixel values.

- Only minor changes are made to pixel values.
- These changes are invisible to the human eye.
- The stego image looks almost identical to the original image.
- Secret data can be securely embedded without noticeable quality loss.

## Features

- Hide secret text inside an image
- Password-based encryption for additional security
- Extract hidden message using the correct password
- Maintains image quality after data embedding
- Provides secure data transmission

## Security Approach

This project provides a **double layer of security**:

1. **Encryption** – Converts the secret message into an unreadable format using a password.
2. **Steganography** – Hides the encrypted message inside an image.

This ensures:
- Confidentiality
- Data protection
- Secure communication

## Technologies Used

- Python
- Image Processing
- LSB Steganography Algorithm
- Encryption Techniques

## Conclusion

LSB-based image steganography with password-based encryption is an effective method for secure data hiding. By combining encryption and steganography, this project provides a reliable approach for protecting sensitive information during digital communication.
