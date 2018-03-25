package info.ditrapani

import java.awt.Color;
import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO

sealed abstract class Side {
  def col: Int
}
object Left extends Side {
  def col = 0
}
object Right extends Side {
  def col = 4
}

sealed abstract class Pole {
  def row: Int
}
object North extends Pole {
  def row = 0
}
object South extends Pole {
  def row = 4
}

sealed abstract class Shade {
  def value: Int
}
object Darkest extends Shade {
  def value = 0
}
object Dark extends Shade {
  def value = 85
}
object Light extends Shade {
  def value = 170
}
object Lightest extends Shade {
  def value = 255
}

object Main {
  private val width = 50
  private val img = new BufferedImage(width * 8, width * 8, BufferedImage.TYPE_INT_RGB)
  private val shades = List(Darkest, Dark, Light, Lightest)

  def main(args: Array[String]): Unit = {
    fourByFour(Darkest, Left, North)
    fourByFour(Dark, Right, North)
    fourByFour(Light, Left, South)
    fourByFour(Lightest, Right, South)
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

  def fourByFour(red: Shade, side: Side, pole: Pole): Unit = {
    for ((green, index) <- shades.zipWithIndex) {
      fourBlues(red, green, side, pole.row + index)
    }
  }

  def fourBlues(red: Shade, green: Shade, side: Side, row: Int): Unit = {
    for ((blue, index) <- shades.zipWithIndex) {
      square(side.col + index, row, new Color(red.value, green.value, blue.value))
    }
  }
}
