install.packages("magick")

library(magick)

# Definir o caminho da pasta onde as imagens estão
caminho_pasta <- file.path(Sys.getenv("USERPROFILE"), "Desktop", "gif")

# Listar os arquivos de imagem (supondo que sejam PNG)
arquivos <- list.files(path = caminho_pasta, pattern = "*.png", full.names = TRUE)

# Carregar as imagens
imagens <- image_read(arquivos)

# Criar a animação (ajuste 'delay' para mudar a velocidade)
gif <- image_animate(imagens, fps = 1)

# Salvar o GIF
image_write(gif, file.path(caminho_pasta, "investimento.gif"))

cat("GIF criado e salvo em:", file.path(caminho_pasta, "investimento.gif"), "\n")
