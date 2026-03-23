using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace CRMFiloServis.Web.Data.Migrations
{
    /// <inheritdoc />
    public partial class FirmaVeCariMuhasebe : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "FirmaId",
                table: "Cariler",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "MuhasebeHesapId",
                table: "Cariler",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Firmalar",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    FirmaKodu = table.Column<string>(type: "character varying(50)", maxLength: 50, nullable: false),
                    FirmaAdi = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: false),
                    UnvanTam = table.Column<string>(type: "character varying(250)", maxLength: 250, nullable: true),
                    VergiNo = table.Column<string>(type: "character varying(11)", maxLength: 11, nullable: true),
                    VergiDairesi = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    Adres = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    Il = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    Ilce = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    Telefon = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    Email = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    WebSite = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: true),
                    Logo = table.Column<string>(type: "text", nullable: true),
                    Aktif = table.Column<bool>(type: "boolean", nullable: false),
                    VarsayilanFirma = table.Column<bool>(type: "boolean", nullable: false),
                    SiraNo = table.Column<int>(type: "integer", nullable: false),
                    AktifDonemYil = table.Column<int>(type: "integer", nullable: false),
                    AktifDonemAy = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    UpdatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Firmalar", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Cariler_FirmaId",
                table: "Cariler",
                column: "FirmaId");

            migrationBuilder.CreateIndex(
                name: "IX_Cariler_MuhasebeHesapId",
                table: "Cariler",
                column: "MuhasebeHesapId");

            migrationBuilder.CreateIndex(
                name: "IX_Firmalar_FirmaKodu",
                table: "Firmalar",
                column: "FirmaKodu",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Cariler_Firmalar_FirmaId",
                table: "Cariler",
                column: "FirmaId",
                principalTable: "Firmalar",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Cariler_MuhasebeHesaplari_MuhasebeHesapId",
                table: "Cariler",
                column: "MuhasebeHesapId",
                principalTable: "MuhasebeHesaplari",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Cariler_Firmalar_FirmaId",
                table: "Cariler");

            migrationBuilder.DropForeignKey(
                name: "FK_Cariler_MuhasebeHesaplari_MuhasebeHesapId",
                table: "Cariler");

            migrationBuilder.DropTable(
                name: "Firmalar");

            migrationBuilder.DropIndex(
                name: "IX_Cariler_FirmaId",
                table: "Cariler");

            migrationBuilder.DropIndex(
                name: "IX_Cariler_MuhasebeHesapId",
                table: "Cariler");

            migrationBuilder.DropColumn(
                name: "FirmaId",
                table: "Cariler");

            migrationBuilder.DropColumn(
                name: "MuhasebeHesapId",
                table: "Cariler");
        }
    }
}
