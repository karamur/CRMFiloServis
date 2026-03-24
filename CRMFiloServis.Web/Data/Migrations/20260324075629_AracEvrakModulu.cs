using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace CRMFiloServis.Web.Data.Migrations
{
    /// <inheritdoc />
    public partial class AracEvrakModulu : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AracEvraklari",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    AracId = table.Column<int>(type: "integer", nullable: false),
                    EvrakKategorisi = table.Column<string>(type: "text", nullable: false),
                    EvrakAdi = table.Column<string>(type: "text", nullable: true),
                    Aciklama = table.Column<string>(type: "text", nullable: true),
                    BaslangicTarihi = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    BitisTarihi = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    HatirlatmaTarihi = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    Tutar = table.Column<decimal>(type: "numeric", nullable: true),
                    SigortaSirketi = table.Column<string>(type: "text", nullable: true),
                    PoliceNo = table.Column<string>(type: "text", nullable: true),
                    Durum = table.Column<int>(type: "integer", nullable: false),
                    HatirlatmaAktif = table.Column<bool>(type: "boolean", nullable: false),
                    HatirlatmaGunOnce = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AracEvraklari", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AracEvraklari_Araclar_AracId",
                        column: x => x.AracId,
                        principalTable: "Araclar",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AracEvrakDosyalari",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    AracEvrakId = table.Column<int>(type: "integer", nullable: false),
                    DosyaAdi = table.Column<string>(type: "text", nullable: false),
                    DosyaYolu = table.Column<string>(type: "text", nullable: false),
                    DosyaTipi = table.Column<string>(type: "text", nullable: true),
                    DosyaBoyutu = table.Column<long>(type: "bigint", nullable: false),
                    Aciklama = table.Column<string>(type: "text", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AracEvrakDosyalari", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AracEvrakDosyalari_AracEvraklari_AracEvrakId",
                        column: x => x.AracEvrakId,
                        principalTable: "AracEvraklari",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AracEvrakDosyalari_AracEvrakId",
                table: "AracEvrakDosyalari",
                column: "AracEvrakId");

            migrationBuilder.CreateIndex(
                name: "IX_AracEvraklari_AracId",
                table: "AracEvraklari",
                column: "AracId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AracEvrakDosyalari");

            migrationBuilder.DropTable(
                name: "AracEvraklari");
        }
    }
}
