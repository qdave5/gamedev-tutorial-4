Author : Qosim Ariqoh Daffa

NPM : 2006522820

Source : https://github.com/CSUI-Game-Development/tutorial-4-template

Godot Version : 3.5

---

# Latihan Mandiri: Membuat Level Baru Dengan Tile Map & Obstacle Berbeda

Sebagai bagian dari latihan mandiri, kamu diminta untuk praktik membuat level baru yang berbeda dari level pertama. Kebutuhan minimum yang harus diimplementasikan pada level baru:

-   Level menggunakan tile map yang berbeda dari level pertama.
-   Terdapat spawner rintangan di level baru yang membuat objek berbeda dari ikan.
-   Memiliki rintangan berupa jurang dan objek yang berjatuhan secara periodik.

Silakan berkreasi lebih lanjut untuk membuat level baru kamu makin menarik! Jangan lupa untuk menjelaskan proses pengerjaan level baru ini di dalam sebuah dokumen teks README.md. Cantumkan juga referensi-referensi yang digunakan sebagai acuan ketika menjelaskan proses implementasi.

---

## Penambahan tile map berbeda

Penerapan menggunakan tile set yang telah dibuat sebelumnya, dengan melakukan proses yang serupa untuk _spritesheets_ dirt, planet, sand, snow, dan stone. Apabila telah terimplementasi, tile map yang menggunakan tile set ini dapat memilih antara keenam _spritesheets_ tersebut (dirt, grass, planet, sand, snow, dan stone) pada level yang ingin dibuat.

## Repeatable Background

reference: [How to Make an Infinite Scrolling Background](https://forum.godotengine.org/t/how-to-make-an-infinite-scrolling-background/24114/3)

Pada `Level1`, ditambahkan sebuah background `colored_land.png` pada `TextureRect`. Supaya background tersebut dapat diperpanjang secara horizontal dan berulang, pada atribut `TextureRect` set `Stretch Mode` menjadi **"Tile"**. Hasil pengulangan dapat terlihat ketika ukuran `TextureRect` tersebut diperpanjang, terutama ketika diperpanjang kebawah akan menampilkan kembali bagian langit dari background `colored_land.png`. Implementasi ini juga digunakan pada gambar laut (yang digunakan sebagai area kalah dari pemain).

Kemudian supaya background `colored_land.png` dapat terlihat seperti background yang jauh dari `Player`, yang ditandai dengan pergerakan yang lambat, digunakan _node_ `ParallaxLayer`. Kecepatan _motion_ dari background dapat diatur dengan atribut `Scale` dengan nilai kurang dari satu (1) sehingga kecepatan dari background diperlambat. Untuk menggunakan _node_ `ParallaxLayer`, diperlukan _node_ `ParallaxBackground` sebagai _parent node_-nya. [`ParallaxBackground`](https://docs.godotengine.org/en/3.5/classes/class_parallaxbackground.html) memanfaatkan satu atau lebih `ParallaxLayer` untuk membuat _parallax effect_ pada background.

---

## Implementasi new mob (obstacle)

### Update implementasi FallingFish

Sebelumnya dilab, terjadi suatu masalah dimana _node_ `FallingFish` yang dibuat tidak mentrigger _signal_ `_body_entered()` yang dimana bermaksud untuk memberikan sinyal ketika `Player` menyentuh `FallingFish`. Solusi yang ditemukan oleh **Ivan Rabbani C.** dari group Discord GameDev adalah dengan memberikan mengatur atribut `Contacts Report` menjadi > 0 dan `Contacts Monitor` menjadi `true`. Setelah dilakukan proses tersebut, _node_ `RigidBody2D` yang dimiliki oleh `FallingFish` akhirnya dapat mengirimkan sinyal ketika terjadi _collision_ dengan objek lain.

Namun, `FallingFish` masih memberikan _bug_, yaitu `FallingFish` akan menghilangkan _platform_ (atau lebih tepatnya `TileMap`) yang telah dibuat dari `Level1`. Masalah ini bisa terjadi dikarenakan implementasi handle sinyal berdasarkan web tutorial 4 gamedev.

```
func _on_FallArea_body_entered(body):
    if body.get_name() == "Player":
        get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
    else:
        body.queue_free()
```

[`queue_free()`](https://docs.godotengine.org/en/3.5/classes/class_node.html#class-node-method-queue-free) merupakan sebuah fungsi yang dimiliki oleh `Node` untuk menghilangkan _node_ tersebut dari _frame_. Berdasarkan kode diatas, _node_ yang dihilangkan adalah `body` yang dimana berarti objek yang menyentuh `FallingFish`. Sehingga apabila `FallingFish` menyentuh _platform_ dan objek selain `Player`, objek tersebut akan dihapus.

Solusi yang dapat dilakukan adalah dengan mengubah `body.queue_free()` menjadi `self.queue_free()` sehingga yang terhapus adalah _node_ `FallingFish`.

```
func _on_FallArea_body_entered(body):
    if body.get_name() == "Player":
        get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
    else:
        self.queue_free()
```

Solusi diatas dapat dikembangkan lebih lanjut dengan mengubah _texture_ dari `FallingFish` menjadi versi _death_-nya dan memberikan waktu sebelum dihilangkan.

```
func _on_RigidBody2D_body_entered(body):
	print(body.get_name())
	if body.get_name() == "Player":
		get_tree().change_scene(str("res://scenes/" + sceneName + ".tscn"))
	else:
		get_node("Sprite").frame_coords.y = 3
		yield(get_tree().create_timer(3), "timeout")
		self.queue_free()
```

`frame_coord` untuk _texture_ fish versi normal adalah (3,2), sedangkan versi *death*nya adalah (3,3).
