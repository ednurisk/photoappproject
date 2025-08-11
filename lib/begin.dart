import 'package:flutter/material.dart';
import 'login_page.dart';

class BeginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        // Background image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/arkaplan.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Top images
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First image with space added
                  Transform.rotate(
                    angle:
                        -0.3, // Bu değeri istediğiniz gibi ayarlayabilirsiniz
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        "assets/kam2.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          40), // Bu değer ile fotoğrafı daha aşağıya kaydırabilirsiniz
                  // Second image with space added
                  Transform.rotate(
                    angle:
                        0.3, // Bu değeri de istediğiniz gibi ayarlayabilirsiniz
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        "assets/kam3.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height:
                    50), // Fotoğraflarla metin arasındaki mesafeyi ayarlayabilirsiniz
            // "Let's Get Started" text
            Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Dikeyde merkezleme
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Yatayda merkezleme
                children: [
                  Text(
                    "Let's Get Started",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // "Join Now" button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Buton rengi siyah olacak
                      padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20), // Buton daha geniş olacak
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            15.0), // Yuvarlak kenarları artırdık
                      ),
                    ),
                    child: Text(
                      "Join Now", // Yazım hatası düzeltildi
                      style: TextStyle(
                        fontSize: 20, // Yazı boyutunu ayarladık
                        color: Colors.white, // Yazı rengi beyaz olacak
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ));
  }
}

