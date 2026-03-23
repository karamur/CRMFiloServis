using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace CRMFiloServis.Web.Data.Migrations
{
    /// <inheritdoc />
    public partial class MuhasebeModulu : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "MuhasebeDonemleri",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Yil = table.Column<int>(type: "integer", nullable: false),
                    Ay = table.Column<int>(type: "integer", nullable: false),
                    BaslangicTarihi = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    BitisTarihi = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Durum = table.Column<int>(type: "integer", nullable: false),
                    KapanisTarihi = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MuhasebeDonemleri", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "MuhasebeFisleri",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    FisNo = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    FisTarihi = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    FisTipi = table.Column<int>(type: "integer", nullable: false),
                    Aciklama = table.Column<string>(type: "text", nullable: true),
                    ToplamBorc = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: false),
                    ToplamAlacak = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: false),
                    Durum = table.Column<int>(type: "integer", nullable: false),
                    Kaynak = table.Column<int>(type: "integer", nullable: false),
                    KaynakId = table.Column<int>(type: "integer", nullable: true),
                    KaynakTip = table.Column<string>(type: "text", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MuhasebeFisleri", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "MuhasebeHesaplari",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    HesapKodu = table.Column<string>(type: "character varying(10)", maxLength: 10, nullable: false),
                    HesapAdi = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    HesapTuru = table.Column<int>(type: "integer", nullable: false),
                    HesapGrubu = table.Column<int>(type: "integer", nullable: false),
                    UstHesapId = table.Column<int>(type: "integer", nullable: true),
                    AltHesapVar = table.Column<bool>(type: "boolean", nullable: false),
                    Aktif = table.Column<bool>(type: "boolean", nullable: false),
                    SistemHesabi = table.Column<bool>(type: "boolean", nullable: false),
                    Aciklama = table.Column<string>(type: "text", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MuhasebeHesaplari", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MuhasebeHesaplari_MuhasebeHesaplari_UstHesapId",
                        column: x => x.UstHesapId,
                        principalTable: "MuhasebeHesaplari",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "MuhasebeFisKalemleri",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    FisId = table.Column<int>(type: "integer", nullable: false),
                    HesapId = table.Column<int>(type: "integer", nullable: false),
                    SiraNo = table.Column<int>(type: "integer", nullable: false),
                    Borc = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: false),
                    Alacak = table.Column<decimal>(type: "numeric(18,2)", precision: 18, scale: 2, nullable: false),
                    Aciklama = table.Column<string>(type: "text", nullable: true),
                    CariId = table.Column<int>(type: "integer", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MuhasebeFisKalemleri", x => x.Id);
                    table.ForeignKey(
                        name: "FK_MuhasebeFisKalemleri_Cariler_CariId",
                        column: x => x.CariId,
                        principalTable: "Cariler",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_MuhasebeFisKalemleri_MuhasebeFisleri_FisId",
                        column: x => x.FisId,
                        principalTable: "MuhasebeFisleri",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_MuhasebeFisKalemleri_MuhasebeHesaplari_HesapId",
                        column: x => x.HesapId,
                        principalTable: "MuhasebeHesaplari",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_MuhasebeDonemleri_Yil_Ay",
                table: "MuhasebeDonemleri",
                columns: new[] { "Yil", "Ay" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_MuhasebeFisKalemleri_CariId",
                table: "MuhasebeFisKalemleri",
                column: "CariId");

            migrationBuilder.CreateIndex(
                name: "IX_MuhasebeFisKalemleri_FisId",
                table: "MuhasebeFisKalemleri",
                column: "FisId");

            migrationBuilder.CreateIndex(
                name: "IX_MuhasebeFisKalemleri_HesapId",
                table: "MuhasebeFisKalemleri",
                column: "HesapId");

            migrationBuilder.CreateIndex(
                name: "IX_MuhasebeFisleri_FisNo",
                table: "MuhasebeFisleri",
                column: "FisNo",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_MuhasebeHesaplari_HesapKodu",
                table: "MuhasebeHesaplari",
                column: "HesapKodu",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_MuhasebeHesaplari_UstHesapId",
                table: "MuhasebeHesaplari",
                column: "UstHesapId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "MuhasebeDonemleri");

            migrationBuilder.DropTable(
                name: "MuhasebeFisKalemleri");

            migrationBuilder.DropTable(
                name: "MuhasebeFisleri");

            migrationBuilder.DropTable(
                name: "MuhasebeHesaplari");
        }
    }
}
