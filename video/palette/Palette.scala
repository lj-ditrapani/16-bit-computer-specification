package info.ditrapani

import java.awt.Color;
import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO

sealed abstract class Side {
  def col: Int
}
object Left extends Side {
  def col: Int = 0
}
object Right extends Side {
  def col: Int = 4
}

object Main {
  private val width = 50
  private val img = new BufferedImage(width * 8, width * 8, BufferedImage.TYPE_INT_RGB)
  private val a = 0
  private val b = 85
  private val c = 170
  private val d = 255
  private val shades = List(a, b, c, d)

  def main(args: Array[String]): Unit = {
    for ((green, index) <- shades.zipWithIndex) {
      fourBlues(a, green, Left, index)
    }
    for ((green, index) <- shades.zipWithIndex) {
      fourBlues(b, green, Right, index)
    }
    for ((green, index) <- shades.zipWithIndex) {
      fourBlues(c, green, Left, 4 + index)
    }
    for ((green, index) <- shades.zipWithIndex) {
      fourBlues(d, green, Right, 4 + index)
    }
    val pngFile = new File("palette.png")
    val gifFile = new File("palette.gif")
    ImageIO.write(img, "png", pngFile)
    ImageIO.write(img, "gif", gifFile)
    (): Unit
  }

  def square(col: Int, row: Int, color: Color): Unit = {
    for (y <- 0.until(width)) {
      for (x <- 0.until(width)) {
        img.setRGB(col * width + y, row * width + x, color.getRGB())
      }
    }
  }

  def fourBlues(red: Int, green: Int, side: Side, row: Int): Unit = {
    for ((blue, index) <- shades.zipWithIndex) {
      square(side.col + index, row, new Color(red, green, blue))
    }
  }
}
