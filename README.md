# GitLab Local (Docker Setup)

Este projeto permite executar uma instância completa do GitLab localmente, com suporte a HTTPS, dados persistentes e configuração portátil entre diferentes máquinas.

---

## 1. Estrutura do projeto

```
gitlab-local/
├── .env
├── docker-compose.yml
├── scripts/
│   └── generate-cert.sh
├── ssl/
├── config/
├── data/
└── logs/
```

---

## 2. Requisitos

- Docker e Docker Compose instalados
- 8 GB de RAM (mínimo recomendado)
- CPU com suporte a virtualização
- Permissões de administrador (sudo)

---

## 3. Configuração inicial

### 3.1. Defina o hostname local

Edite o arquivo `.env` e defina o nome do host:

```env
HOSTNAME=gitlab.local
```

Cada usuário pode definir seu próprio hostname (por exemplo, `gitlab.marlon.local`, `gitlab.dev.local`, etc).

---

### 3.2. Gere o certificado SSL

Execute o script para criar o certificado correspondente ao hostname definido no `.env`:

```bash
chmod +x scripts/generate-cert.sh
./scripts/generate-cert.sh
```

Isso criará os arquivos:

```
ssl/gitlab.local.crt
ssl/gitlab.local.key
```

---

### 3.3. Adicione o hostname no /etc/hosts

Abra o arquivo de hosts do sistema:

```bash
sudo nano /etc/hosts
```

Adicione a linha:

```
127.0.0.1 gitlab.local
```

Substitua pelo hostname configurado no `.env`, se for diferente.

---

## 4. Subir o container

Execute:

```bash
sudo docker compose up -d
```

A primeira inicialização pode levar de 10 a 15 minutos.  
Durante este tempo, o status do container aparecerá como `(health: starting)`.

Verifique o progresso com:

```bash
sudo docker logs -f gitlab
```

Quando o log exibir mensagens como `ok: run: unicorn` ou `ok: run: nginx`, o GitLab estará pronto.

---

## 5. Acessar a interface

Abra no navegador:

- HTTPS: [https://gitlab.local](https://gitlab.local)
- HTTP (temporário): [http://gitlab.local](http://gitlab.local)

Para obter a senha inicial do usuário root:

```bash
sudo docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

Usuário: `root`

---

## 6. Estrutura de dados persistentes

Os dados do GitLab são armazenados localmente:

| Diretório | Conteúdo |
|------------|-----------|
| `config/`  | Configurações do GitLab |
| `data/`    | Banco de dados, repositórios e uploads |
| `logs/`    | Logs de execução |
| `ssl/`     | Certificados SSL locais |

Esses diretórios garantem que, ao remover ou atualizar o container, as informações permaneçam preservadas.

---

## 7. Encerrar ou reiniciar o serviço

Para parar o GitLab:

```bash
sudo docker compose down
```

Para reiniciar:

```bash
sudo docker compose down
sudo docker compose up -d
```

---

## 8. Backup manual

Para criar um backup completo dos dados:

```bash
sudo docker exec -t gitlab gitlab-backup create
```

Os arquivos de backup são salvos em `/var/opt/gitlab/backups`.

---

## 9. Dicas

- A primeira execução é a mais demorada, pois o GitLab executa várias tarefas internas de configuração.
- Certifique-se de manter o mesmo hostname entre o certificado, o `.env` e o `/etc/hosts`.
- Caso o HTTPS falhe, verifique se os arquivos `.crt` e `.key` foram corretamente gerados e estão montados no container.
- O projeto é compatível com Linux, macOS e WSL2 (Windows).

---

## 10. Próximos passos

- Configurar GitLab Runner local para CI/CD
- Adicionar pipelines automatizados para builds de firmware (ex: U-Boot)
- Sincronizar repositórios entre máquinas via backup ou mirroring

---

### Autor

Configuração desenvolvida para uso interno e educativo, voltada à automação de builds e versionamento seguro em ambiente local.