library(geobr)
library(ggplot2)
library(sf)
library(readxl)
library(dplyr)
library(patchwork) # Para organizar os gráficos
library(cowplot)   # Para extrair legendas

# Definir o caminho correto do arquivo na Área de Trabalho
file_path <- file.path(Sys.getenv("USERPROFILE"), "Desktop", "1investimento - Copia.xlsx")

# Carregar os dados do arquivo Excel
dados <- read_excel(file_path, sheet = "Planilha1", col_names = TRUE)

# Pegar o ano da primeira linha da coluna D
dados_coluna <- names(dados)[4]  # Supondo que a primeira coluna com valores seja D
ano <- dados[1, 4]  # Obtém o ano da célula D1

dados <- dados[-1, ]  # Remove a primeira linha com os anos

# Ajustar nomes das colunas
colnames(dados) <- c("Sigla", "code_muni", "Municipio", "Valor")

# Baixar os shapefiles dos municípios e estados
municipios <- read_municipality(year = 2020, showProgress = FALSE)
estados <- read_state(year = 2020, showProgress = FALSE)

# Converter código do município para numérico e garantir merge correto
dados$code_muni <- as.numeric(dados$code_muni)
dados$Valor <- as.numeric(dados$Valor)

# Unir os dados com os shapefiles dos municípios
mapa_dados <- left_join(municipios, dados, by = "code_muni")

# Definir a escala fixa
valor_max <- 50000000
valor_min <- 1000

# Criar uma função para gerar o mapa
criar_mapa <- function(dados_coluna, titulo) {
  ggplot() +
    geom_sf(data = mapa_dados, aes(fill = Valor), color = NA) +
    geom_sf(data = estados, fill = NA, color = "black", size = 0.5) +
    scale_fill_gradientn(
      colours = c("yellow", "orange", "red", "darkred"),
      trans = "log",
      na.value = "white",
      limits = c(valor_min, valor_max)
    ) +
    theme_minimal() +
    theme(
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      axis.title = element_blank(),
      panel.grid = element_blank()
    ) +
    labs(title = "Investimento 2021", fill = "Valor (Escala Log)")
}

# Criar o mapa para o ano correspondente
mapa <- criar_mapa("Valor", "Investimento 2021")

# Exibir o resultado
print(mapa)

# Salvar a imagem final
ggsave(paste0("mapa_investimento_2021.png"), plot = mapa, width = 15, height = 10, dpi = 300)

cat("Mapa gerado e salvo como", paste0("mapa_investimento_2021.png"), "na pasta de trabalho:", getwd(), "\n")

# Instalar pacotes necessários
install.packages("ggplot2", dependencies = TRUE)
install.packages("dplyr", dependencies = TRUE)
install.packages("cowplot", dependencies = TRUE)
install.packages("patchwork", dependencies = TRUE)
install.packages("readxl", dependencies = TRUE)
install.packages("sf", dependencies = TRUE)
install.packages("geobr", dependencies = TRUE)
