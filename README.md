# 🎬 Movies App

Aplicativo Flutter para listagem de filmes em cartaz, com suporte a cache local, busca e atualização manual dos dados.

---

## 🚀 Tecnologias utilizadas

- Flutter
- Riverpod (StateNotifier)
- Dio
- Hive (cache local)
- Clean Architecture
- TMDB API

---

## 📱 Funcionalidades

- Listagem de filmes
- Paginação infinita
- Pull to refresh
- Atualização manual via botão
- Cache offline com Hive
- Busca de filmes
- Detalhes do filme (gêneros, sinopse, lançamento)

---

## 🔐 Configuração da API

Este projeto utiliza a **TMDB API**.

A chave da API é passada via `--dart-define` para evitar exposição no código.

### ▶️ Como rodar o projeto

```bash
flutter pub get
flutter run --dart-define=TMDB_API_KEY=SUA_API_KEY

