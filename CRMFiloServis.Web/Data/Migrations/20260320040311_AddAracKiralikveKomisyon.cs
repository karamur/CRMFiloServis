using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CRMFiloServis.Web.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddAracKiralikveKomisyon : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<decimal>(
                name: "AylikKiraBedeli",
                table: "Araclar",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "GunlukKiraBedeli",
                table: "Araclar",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "KiraHesaplamaTipi",
                table: "Araclar",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "KiralikCariId",
                table: "Araclar",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "KomisyonHesaplamaTipi",
                table: "Araclar",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "KomisyonOrani",
                table: "Araclar",
                type: "numeric(5,2)",
                precision: 5,
                scale: 2,
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "KomisyonVar",
                table: "Araclar",
                type: "boolean",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "KomisyoncuCariId",
                table: "Araclar",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<decimal>(
                name: "SabitKomisyonTutari",
                table: "Araclar",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "SahiplikTipi",
                table: "Araclar",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<decimal>(
                name: "SeferBasinaKiraBedeli",
                table: "Araclar",
                type: "numeric(18,2)",
                precision: 18,
                scale: 2,
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Araclar_KiralikCariId",
                table: "Araclar",
                column: "KiralikCariId");

            migrationBuilder.CreateIndex(
                name: "IX_Araclar_KomisyoncuCariId",
                table: "Araclar",
                column: "KomisyoncuCariId");

            migrationBuilder.AddForeignKey(
                name: "FK_Araclar_Cariler_KiralikCariId",
                table: "Araclar",
                column: "KiralikCariId",
                principalTable: "Cariler",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Araclar_Cariler_KomisyoncuCariId",
                table: "Araclar",
                column: "KomisyoncuCariId",
                principalTable: "Cariler",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Araclar_Cariler_KiralikCariId",
                table: "Araclar");

            migrationBuilder.DropForeignKey(
                name: "FK_Araclar_Cariler_KomisyoncuCariId",
                table: "Araclar");

            migrationBuilder.DropIndex(
                name: "IX_Araclar_KiralikCariId",
                table: "Araclar");

            migrationBuilder.DropIndex(
                name: "IX_Araclar_KomisyoncuCariId",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "AylikKiraBedeli",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "GunlukKiraBedeli",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "KiraHesaplamaTipi",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "KiralikCariId",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "KomisyonHesaplamaTipi",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "KomisyonOrani",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "KomisyonVar",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "KomisyoncuCariId",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "SabitKomisyonTutari",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "SahiplikTipi",
                table: "Araclar");

            migrationBuilder.DropColumn(
                name: "SeferBasinaKiraBedeli",
                table: "Araclar");
        }
    }
}
