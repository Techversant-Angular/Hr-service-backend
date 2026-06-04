const excelJS = require("exceljs");

async function excelGenerator(req, res, head, body, name) {
  const workbook = new excelJS.Workbook();
  const worksheet = workbook.addWorksheet("Users");

  // Define columns in the worksheet
  worksheet.columns = head;

  // Add data to the worksheet
  body.forEach((element) => {
    worksheet.addRow(element);
  });

  // Set up the response headers
  res.setHeader(
    "Content-Type",
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  );
  res.setHeader(
    "Content-Disposition",
    `attachment; filename="${name}.xlsx"`
  );

  // Write the workbook to the response object
  await workbook.xlsx.write(res);
  res.end();
}

module.exports = { excelGenerator };
