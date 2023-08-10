provider "google" {
  project = GKE-Moringa
  region  = "europe-central2"
  zone    = "europe-central2-a"
}

resource "google_compute_instance" "default" {
  count        = length(var.instances)
  name         = var.instances[count.index]
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "${var.user}"
      timeout     = "500s"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }

    inline = [
      "touch /tmp/temp.txt",
    ]

   
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}


  metadata_startup_script = "sudo apt-add-repository ppa:ansible/ansible; sudo apt update; sudo apt install ansible"
}